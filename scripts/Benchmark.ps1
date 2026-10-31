param([string]$Model='qwen3:8b', [int]$Runs=3)
$ErrorActionPreference='Stop'
if ($Runs -lt 1 -or $Runs -gt 20) { throw 'Runs must be between 1 and 20.' }
$out = Join-Path (Split-Path $PSScriptRoot -Parent) 'results'
New-Item $out -ItemType Directory -Force | Out-Null
$body = @{model=$Model; prompt='Write a complete Python implementation of an LRU cache. Explain the time complexity of get and put.'; stream=$false; options=@{temperature=0; seed=89; num_predict=4096}} | ConvertTo-Json -Depth 5
$records = for ($i=0; $i -le $Runs; $i++) {
    $r=Invoke-RestMethod 'http://127.0.0.1:11434/api/generate' -Method Post -Body $body -ContentType 'application/json' -TimeoutSec 600
    if (-not $r.done -or $r.eval_duration -le 0) { throw 'Incomplete result or invalid evaluation duration.' }
    [pscustomobject]@{run=$i; warmup=($i -eq 0); model=$Model; generated_tokens=$r.eval_count; tokens_per_second=($r.eval_count/($r.eval_duration/1e9)); total_seconds=($r.total_duration/1e9); load_seconds=($r.load_duration/1e9); prompt_tokens=$r.prompt_eval_count; timestamp=(Get-Date).ToUniversalTime().ToString('o')}
}
$records | ConvertTo-Json | Set-Content (Join-Path $out 'benchmark.json') -Encoding UTF8
$records | Format-Table
