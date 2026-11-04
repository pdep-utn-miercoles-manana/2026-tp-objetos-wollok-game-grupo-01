# Ejecuta el juego en una ventana de Chrome/Edge en modo kiosco (pantalla completa)
# y apaga el servidor cuando se cierra esa ventana.

$ErrorActionPreference = "Stop"
$project = $PSScriptRoot
$server = $null
$browser = $null
$profile = Join-Path $env:TEMP ("wollok-kiosco-" + [guid]::NewGuid().ToString("N"))
$failed = $false

function Test-Port {
    param([int]$Port)
    try {
        if (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) {
            return $true
        }
    } catch { }

    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $client.Connect("localhost", $Port)
        return $true
    } catch {
        return $false
    } finally {
        $client.Dispose()
    }
}

function Find-FreePort {
    $port = 3000
    while ((Test-Port $port) -and $port -lt 3100) {
        $port++
    }
    if ($port -ge 3100) {
        throw "No encontre un puerto libre entre 3000 y 3099."
    }
    return $port
}

function Find-Browser {
    $candidates = @(
        (Join-Path $env:ProgramFiles "Google\Chrome\Application\chrome.exe"),
        (Join-Path ${env:ProgramFiles(x86)} "Google\Chrome\Application\chrome.exe"),
        (Join-Path $env:LOCALAPPDATA "Google\Chrome\Application\chrome.exe"),
        (Join-Path $env:ProgramFiles "Microsoft\Edge\Application\msedge.exe"),
        (Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe")
    )
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }
    return $null
}

function Stop-GameServer {
    if ($server -and -not $server.HasExited) {
        & taskkill.exe /PID $server.Id /T /F 2>$null | Out-Null
    }
}

try {
    Set-Location -LiteralPath $project

    if (-not (Get-Command wollok -ErrorAction SilentlyContinue)) {
        throw "No encontre el comando 'wollok'. Instalalo con: npm install -g wollok-ts-cli"
    }

    $browserPath = Find-Browser
    if (-not $browserPath) {
        throw "No encontre Chrome ni Edge. Instala uno para abrir el juego en pantalla completa."
    }

    $port = Find-FreePort
    $url = "http://localhost:$port"

    Write-Host ""
    Write-Host "  November is Coming - UTN FRBA" -ForegroundColor Cyan
    Write-Host "  Iniciando servidor..." -ForegroundColor DarkGray

    $serverCommand = "wollok run juego.programaPrincipal --port $port"
    $server = Start-Process -FilePath "powershell.exe" `
        -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $serverCommand) `
        -WorkingDirectory $project `
        -PassThru `
        -WindowStyle Hidden

    $ready = $false
    for ($i = 0; $i -lt 80; $i++) {
        if ($server.HasExited) {
            throw "El servidor de Wollok se cerro antes de estar listo."
        }
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 1
            if ($response.StatusCode -eq 200) {
                $ready = $true
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if (-not $ready) {
        throw "El servidor no respondio en $url."
    }

    Write-Host "  Servidor listo en $url" -ForegroundColor Green
    Write-Host "  Abriendo el juego en pantalla completa..." -ForegroundColor DarkGray
    Write-Host "  Para salir: cerra la ventana con Alt+F4." -ForegroundColor Yellow
    Write-Host ""

    $browserArgs = @(
        "--kiosk",
        "--app=$url",
        "--user-data-dir=$profile",
        "--no-first-run",
        "--no-default-browser-check",
        "--disable-background-mode",
        "--disable-session-crashed-bubble",
        "--autoplay-policy=no-user-gesture-required"
    )

    $browser = Start-Process -FilePath $browserPath -ArgumentList $browserArgs -PassThru
    $browser.WaitForExit()

    Write-Host "  Cerrando servidor..." -ForegroundColor DarkGray
} catch {
    Write-Host ""
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Revisa que Wollok este instalado y que el proyecto compile." -ForegroundColor DarkGray
    $failed = $true
} finally {
    Stop-GameServer
    Start-Sleep -Milliseconds 500
    if (Test-Path -LiteralPath $profile) {
        Remove-Item -LiteralPath $profile -Recurse -Force -ErrorAction SilentlyContinue
    }
}

if ($failed) {
    exit 1
}
