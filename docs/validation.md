# Validation record

Package status: partial runtime validation on the reference Windows host, reported
by Alessandro on October 31, 2026. The isolated WebUI uses the existing Ollama
service; this is not validation of a fresh Windows/service installation.

Evidence: owner supplied health status True and container-to-Ollama HTTP 200,
confirmed Test-Setup.ps1 -Generate finished successfully, confirmed browser chat
and absence of a signup option, and confirmed the conversation survived
`docker compose down` followed by `Start-WebUI.ps1`.

The owner verified the original installation generates responses, requires login,
has signup disabled and becomes available after Windows sign-in. These observations
do not establish that the new package works on a fresh machine.

| Test | Expected | Package result |
|---|---|---|
| Compose config | Valid rendered configuration | Passed via successful script run |
| Fresh volume | Administrator can be created locally | Working browser session reported; bootstrap not separately recorded |
| Lock signup | Anonymous signup unavailable after normal start | Signup option absent, owner reported; API-level denial not tested |
| Authentication | Anonymous chat unavailable | Pending |
| Host API | qwen3:8b listed | Passed via successful script run, including generation |
| Container API | Host Ollama reachable from container | Passed: HTTP 200 |
| Browser generation | Complete response through WebUI | Passed, owner reported |
| GPU | Ollama reports model on GPU | Passed: owner supplied `ollama ps`, 100% GPU |
| Persistence | Test chat survives compose down/up | Passed, owner reported |
| Private HTTPS | Authorized client can log in and generate | Pending |
| Restrictions | Unintended routes cannot access UI/API | Pending |
| Restart | Works after Windows sign-in | Pending |
| Failure recovery | Stop/start test services; connectivity restores | Pending |
| Second machine | README followed without hidden local state | Pending |

Record date, hardware, versions, image digest, model ID, commands and observed
results. Keep failed tests and corrective steps. Do not publish passwords or chat
content. Do not test failure recovery against a shared active session without
coordinating downtime. A one-machine isolated test is not fresh-machine validation.

## GPU evidence (October 31, 2026)

Owner-supplied `ollama ps`: qwen3:8b, ID 500a1f067a9f, size 5.6 GB,
PROCESSOR 100% GPU, active context 4096. This confirms full GPU placement reported
by Ollama, not a throughput measurement. The accompanying NVIDIA-SMI screenshot
shows RTX 5070, driver 610.88, 96% device utilization and 8,175 / 12,227 MiB
VRAM usage. Those device-wide figures include other applications and must not be
attributed solely to Ollama. Private paths and unrelated process listings are omitted.

## Benchmark evidence (October 31, 2026)

Owner-supplied output from `scripts/Benchmark.ps1` on the reference RTX 5070
host: [raw results](benchmarks/2026-10-31-qwen3-8b.json).

| Run | Generated tokens | Generation tokens/s | Total seconds |
|---|---:|---:|---:|
| 0 (warmup, excluded) | 2316 | 105.97 | 22.07 |
| 1 | 4096 | 103.79 | 39.74 |
| 2 | 2316 | 107.28 | 21.82 |
| 3 | 4096 | 102.42 | 40.17 |

Arithmetic mean of the three measured rates: **104.50 tokens/s**; range
**102.42–107.28 tokens/s**. Aggregate generation throughput, calculated as total
tokens divided by summed generation durations inferred from the recorded rates:
**103.99 tokens/s**. These exclude loading and prompt processing; total request
durations are shown separately.

The script uses an LRU-cache implementation prompt, temperature 0, seed 89 and
`num_predict=4096`. Runs 1 and 3 reached that output limit and may have stopped
before completing the answer. The recorded JSON lacks stop reasons and answer
text, so completion and answer quality cannot be established. Output lengths
vary, and this small sample is not a general performance guarantee. The script
does not explicitly set or record active context; the earlier 4096 context
observation is separate evidence. This validates inference through the existing
Ollama service, not a fresh-machine installation or end-to-end browser latency.
