param([switch]$Bootstrap)
$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
$previous = $env:ENABLE_SIGNUP
try {
    if ($Bootstrap) { $env:ENABLE_SIGNUP = 'true' }
    else { $env:ENABLE_SIGNUP = 'false' }
    docker compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Invalid Compose configuration.' }
    docker compose up -d
    if ($LASTEXITCODE -ne 0) { throw 'Deployment failed.' }
    if ($Bootstrap) {
        Write-Host 'Create your first administrator at http://127.0.0.1:8089 (or your configured port).'
        Write-Host 'Before enabling remote access, rerun this script WITHOUT -Bootstrap to disable signup.'
    }
} finally { $env:ENABLE_SIGNUP = $previous; Pop-Location }
