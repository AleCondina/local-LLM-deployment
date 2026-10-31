# Native Ollama service

The reference service is named Ollama, uses NSSM 2.24, starts automatically and
runs `ollama.exe serve` with its executable directory as the working directory.
The reference service account and effective machine environment were not captured.
No custom OLLAMA variables were returned from the inspected AppEnvironmentExtra.
Do not infer that the process has no inherited environment variables.

On a fresh machine, install NSSM from its official source. Exit the Ollama tray
application and disable its duplicate startup entry before starting the service.
Do not run two servers on port 11434. In elevated PowerShell, substitute real paths:

```powershell
$nssm = 'C:\Tools\nssm\win64\nssm.exe'
$ollama = Join-Path $env:LOCALAPPDATA 'Programs\Ollama\ollama.exe'
if (!(Test-Path $nssm) -or !(Test-Path $ollama)) { throw 'Check installation paths.' }
if (Get-Service Ollama -ErrorAction SilentlyContinue) { throw 'Service already exists; inspect it instead.' }
& $nssm install Ollama $ollama serve
& $nssm set Ollama AppDirectory (Split-Path $ollama)
& $nssm set Ollama Start SERVICE_AUTO_START
& $nssm edit Ollama
```

Check each NSSM command for success. In the service editor's Log on tab choose an
appropriate service identity. Grant that identity access to the executable and model
folder. Do not place account passwords in scripts or commits. LocalSystem has a
different profile/model directory from your desktop user. Prefer an explicit model
folder accessible to the selected identity, set through NSSM AppEnvironmentExtra
(`OLLAMA_MODELS=C:\LocalAI\models`). Preserve existing environment entries if editing.
Start with `Start-Service Ollama`; then run `ollama pull qwen3:8b` against that server.
Model downloads are managed by the server identity. Verify with `ollama list`.

## Container connectivity

Test the host API, then run scripts/Test-Setup.ps1 to test from inside Docker.
The reference WebUI uses http://host.docker.internal:11434. If host access works but
container access fails, inspect the actual listening address, effective OLLAMA_HOST,
Docker Desktop networking and firewall. Capture these before changing them:

```powershell
Get-NetTCPConnection -State Listen -LocalPort 11434
[Environment]::GetEnvironmentVariable('OLLAMA_HOST','Machine')
[Environment]::GetEnvironmentVariable('OLLAMA_HOST','User')
```

Binding Ollama to all interfaces can make its unauthenticated API network-accessible.
If a broader bind is required on a particular host, restrict inbound access with
Windows firewall to the necessary Docker path and verify from another LAN machine.
Do not add a blanket inbound allow rule. This host-dependent step is deliberately
manual until the network path is verified. The package is a reproducible deployment
guide with automated WebUI setup, not an unattended OS/network installer.
