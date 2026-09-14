# seekrit-wasmcloud

Serve seekrit secrets to a [wasmCloud](https://wasmcloud.com) lattice.

Deploys `seekrit-wasmcloud-secrets`, which answers wasmCloud's `v1alpha1` NATS secrets API next to your hosts: it
holds the service token, resolves and decrypts locally, and seals each value to
the requesting host's xkey. Your components ask wasmCloud for secrets the usual
way — `wash config put`, a `secrets` block in the wadm manifest — and the
seekrit API never sees a plaintext value.

This is the wasmCloud counterpart to `seekrit-eso`: the same shape (a
customer-hosted resolver plus a chart to deploy it), pointed at a lattice
instead of at the External Secrets Operator.

## Install

```bash
helm repo add seekrit https://charts.seekrit.dev
helm install seekrit-wasmcloud seekrit/seekrit-wasmcloud \
  --namespace wasmcloud --create-namespace \
  --set profiles.checkout.token=skt_… \
  --set profiles.checkout.issuers[0]=ACCOUNT_PUBLIC_KEY \
  --set nats.url=nats://nats:4222
```

Or without adding a repository, from the OCI artifact:
`helm install seekrit-wasmcloud oci://registry-1.docker.io/seekritdev/seekrit-wasmcloud`.

Mint the token with `seekrit token create --name wasmcloud --app <app> --env <env>`;
find your account key with `wash keys list`.

## Two things this chart cannot do for you

Both fail **silently** — the backend runs, the lattice just never asks it:

1. **Hosts must be started with `--secrets-topic-prefix wasmcloud.secrets`**
   (matching `backend.subjectPrefix`), and their NATS user must be allowed to
   publish under that subtree.
2. **Each secret needs a config entry** naming the backend:

   ```bash
   wash config put SECRET_database_url \
     backend=seekrit \
     key=DATABASE_URL \
     type=secret.wasmcloud.dev/v1alpha1
   ```

   then a `secrets` block on the component in your wadm manifest.

Verify reachability from a host's NATS:

```bash
nats req 'wasmcloud.secrets.v1alpha1.seekrit.server_xkey' ''
```

## Who may read what

Profiles are operator-declared and live only in a Secret mounted into the
backend; a workload can name a *secret*, never the credential used to fetch it.
Matchers **AND** together, so declaring more narrows and never widens:

| Key | What it is | Strength |
|---|---|---|
| `issuers` | account keys (`A…`) allowed to have signed the entity JWT | **the trust anchor** |
| `entities` | component (`M…`) / provider (`V…`) subject keys | narrows |
| `applications` | wadm application names | unsigned; narrows only |

An nkeys JWT is self-issued: anyone can mint a keypair and sign a token claiming
any `sub`, and it verifies. What a signature proves is that the holder of `iss`
vouched for that `sub` — which is why a profile declaring nothing but
`applications` is refused at render time rather than quietly trusted.

Selection is default-deny, and an identity matching more than one profile is
refused rather than resolved to either.

```yaml
profiles:
  checkout:
    token: skt_...
    issuers: ["ACCOUNT_PUBLIC_KEY"]
    applications: ["checkout"]
  billing:
    token: skt_...
    issuers: ["ACCOUNT_PUBLIC_KEY"]
    applications: ["billing"]
```

For GitOps, put the whole document in your own Secret and set `existingSecret`
instead.

## Scaling past one replica

`replicaCount > 1` requires `backend.xkeySeed`, and the chart refuses to render
without it. `server_xkey` and `get` are separate requests over a shared NATS
queue group, so they can land on different pods; without one seed between them
each pod advertises its own key and every request fails to open. Generate one:

```bash
wash keys gen curve
```

Setting a seed is worth it at one replica too — otherwise a restart invalidates
any key a host had cached.

## Values

| Key | Default | Notes |
|---|---|---|
| `profiles` | `{}` | Required (or `existingSecret`). See above. |
| `existingSecret` / `existingSecretKey` | `""` / `wasmcloud.json` | Bring your own profile file. |
| `nats.url` | `nats://nats:4222` | The lattice's NATS. |
| `nats.existingSecret` / `...Key` | `""` / `nats.creds` | NATS credentials, when the lattice authenticates clients. |
| `backend.name` | `seekrit` | The `backend=` value in `wash config put`. |
| `backend.subjectPrefix` | `wasmcloud.secrets` | Must match the hosts' `--secrets-topic-prefix`. |
| `backend.xkeySeed` | `""` | Required for `replicaCount > 1`. |
| `seekrit.apiUrl` | `https://api.seekrit.dev` | |
| `refreshInterval` | `60s` | Also the bound on how long a revoked token keeps working. |
| `otel.endpoint` | `""` | OTLP/HTTP base URL, to **your** collector. Empty exports nothing. |
| `replicaCount` | `1` | |

Full list with comments: [`values.yaml`](values.yaml).

## Startup behaviour

Fail-closed: every profile resolves and decrypts before the backend subscribes,
so a bad token or an unreachable API stops the pod coming up rather than
registering a backend that answers `SecretNotFound` for everything. Refreshes
after that are lenient — a failed re-resolve keeps the last good snapshot and
retries — so an API blip does not take every component's credentials with it.

## Telemetry

Opt-in and to **your** collector, never to seekrit. Spans carry secret *names*,
the signed identity that asked, and outcomes; never values and never tokens.
See <https://seekrit.dev/docs/guides/telemetry>.

---

Docs: <https://seekrit.dev/docs/guides/wasmcloud>
