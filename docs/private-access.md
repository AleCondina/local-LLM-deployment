# Private HTTPS access

Install and authenticate Tailscale on the host and allowed clients. Enable HTTPS
when prompted. For a fresh permanent deployment using port 8089:

```powershell
tailscale serve status
tailscale serve --bg http://127.0.0.1:8089
tailscale serve status
```

These commands can replace an existing root forwarding route. On the reference
machine, keep the existing 8088 route during local testing; schedule a deliberate
switch only after validation. Tailscale Funnel is not part of this setup.

In the tailnet policy, assign a server tag you control, configure its tag owners,
and grant selected users/devices access to that server on TCP 443. Merge with the
existing policy; do not replace all policy content. Check other grants for broader
access. The reference also permits a Mac direct API access on 11434 and another
service on 21118; neither is required for WebUI HTTPS and neither is included by
default. Use placeholders rather than real account/device addresses in published
examples. Keep Open WebUI login enabled as a separate authentication layer.

Validate from an authorized client, a non-authorized tailnet client if available,
and a LAN client without the allowed Tailscale route. Record actual outcomes.
