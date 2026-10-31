param([int]$Port = 8089, [string]$Model = 'qwen3:8b', [switch]$Generate)
$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
try {
    docker compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Compose configuration failed.' }
    Invoke-RestMethod "http://127.0.0.1:$Port/health" | Out-Host
    $tags = Invoke-RestMethod 'http://127.0.0.1:11434/api/tags'
    if ($tags.models.name -notcontains $Model) { throw "Model missing: $Model" }
    docker compose exec -T webui python -c "import urllib.request; r=urllib.request.urlopen('http://host.docker.internal:11434/api/tags',timeout=15); print('Container to Ollama HTTP',r.status)"
    if ($LASTEXITCODE -ne 0) { throw 'Container cannot reach Ollama.' }
    if ($Generate) {
        $body = @{model=$Model; prompt='Reply with one short sentence about computing.'; stream=$false} | ConvertTo-Json
        $result = Invoke-RestMethod 'http://127.0.0.1:11434/api/generate' -Method Post -ContentType 'application/json' -Body $body -TimeoutSec 300
        if (-not $result.done -or -not $result.response) { throw 'No completed model response.' }
        $result.response | Out-Host
    }
    Write-Host 'Automated checks passed. Complete browser, access-control and reboot checks in docs/validation.md.'
} finally { Pop-Location }
