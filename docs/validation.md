# Validation record

Package status: static review only. Windows, Docker Desktop, GPU and Tailscale tests
must be completed on the target machine. No runtime passes are claimed here.

The owner verified the original installation generates responses, requires login,
has signup disabled and becomes available after Windows sign-in. These observations
do not establish that the new package works on a fresh machine.

| Test | Expected | Package result |
|---|---|---|
| Compose config | Valid rendered configuration | Pending target test |
| Fresh volume | Administrator can be created locally | Pending |
| Lock signup | Anonymous signup unavailable after normal start | Pending |
| Authentication | Anonymous chat unavailable | Pending |
| Host API | qwen3:8b listed | Pending |
| Container API | Host Ollama reachable from container | Pending |
| Browser generation | Complete response through WebUI | Pending |
| GPU | Ollama process/offload visible during request | Pending |
| Persistence | Test chat survives compose down/up | Pending |
| Private HTTPS | Authorized client can log in and generate | Pending |
| Restrictions | Unintended routes cannot access UI/API | Pending |
| Restart | Works after Windows sign-in | Pending |
| Failure recovery | Stop/start test services; connectivity restores | Pending |
| Second machine | README followed without hidden local state | Pending |

Record date, hardware, versions, image digest, model ID, commands and observed
results. Keep failed tests and corrective steps. Do not publish passwords or chat
content. Do not test failure recovery against a shared active session without
coordinating downtime. A one-machine isolated test is not fresh-machine validation.
