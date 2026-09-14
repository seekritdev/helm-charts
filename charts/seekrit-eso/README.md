# seekrit-eso

Sync [seekrit](https://seekrit.dev) secrets into Kubernetes with the
[External Secrets Operator](https://external-secrets.io) (ESO) — on **stock,
unmodified ESO**.

seekrit is zero-knowledge: its API only ever returns ciphertext, so ESO can't
read from it directly. This chart deploys the **`seekrit-sdk-server`** sidecar,
which holds a service token, decrypts locally, and serves the plaintext over a
small authed HTTP API — then generates a **webhook `SecretStore`** so you write
only `ExternalSecret` resources.

```
ExternalSecret ─▶ ESO ──webhook──▶ seekrit-sdk-server ──/v1/resolve──▶ seekrit API
 (you write)     (stock)           (this chart)                        (ciphertext only)
```

## Prerequisites

- External Secrets Operator installed in the cluster (this chart does **not**
  bundle it, so it never collides with an existing ESO install):
  ```sh
  helm repo add external-secrets https://charts.external-secrets.io
  helm install external-secrets external-secrets/external-secrets \
    -n external-secrets --create-namespace
  ```
- A seekrit **service token** bound to the app environment you want to sync:
  ```sh
  seekrit token create --name eso --app <app> --env <env>   # prints skt_…
  ```

## Install

```sh
helm repo add seekrit https://charts.seekrit.dev
helm install seekrit-eso seekrit/seekrit-eso \
  -n seekrit-system --create-namespace \
  --set seekrit.token=skt_…
```

Or without adding a repository, from the OCI artifact:
`helm install seekrit-eso oci://registry-1.docker.io/seekritdev/seekrit-eso`.

Then create an `ExternalSecret` (see the post-install notes, or the
[Kubernetes guide](https://seekrit.dev/docs/guides/kubernetes)).

## Key values

| Key | Default | Description |
| --- | --- | --- |
| `seekrit.token` | `""` | Service token (`skt_…`). Required unless `existingSecret` is set. |
| `seekrit.existingSecret` | `""` | Name of a Secret you manage that holds the token (GitOps/sealed-secrets). |
| `seekrit.existingSecretTokenKey` | `token` | Key within `existingSecret`. |
| `seekrit.apiUrl` | `https://api.seekrit.dev` | seekrit API base URL. |
| `refreshInterval` | `60s` | How often the sidecar re-resolves (picks up rotations). |
| `cache.enabled` | `false` | Start from the last-known-good (encrypted) resolve response when the seekrit API is unreachable. |
| `cache.maxAge` | `24h` | How stale that copy may be and still be used. |
| `cache.mountPath` | `/var/cache/seekrit` | Where the cache volume is mounted. |
| `cache.volume` | `{}` (an `emptyDir`) | The volume itself — set a PVC to survive rescheduling. |
| `sidecar.apiKey` | auto | Bearer key ESO presents to the sidecar. Auto-generated + preserved across upgrades if empty. |
| `secretStore.kind` | `SecretStore` | `SecretStore` (namespaced) or `ClusterSecretStore`. |
| `secretStore.name` | `seekrit` | Name your `ExternalSecret`s reference. |
| `networkPolicy.enabled` | `false` | Restrict sidecar ingress to your ESO pods (set `networkPolicy.from`). |

## Notes

- **One token = one environment.** To sync another app/env, install another
  release with its own token and `secretStore.name`.
- **Security posture.** The sidecar serves plaintext over in-cluster HTTP gated
  by an API key. For defense-in-depth, enable `networkPolicy` and turn on etcd
  encryption-at-rest for the Secrets ESO writes. (Plaintext landing in a k8s
  Secret is inherent to how ESO works.)
- **Surviving a seekrit outage.** The first resolve is fail-closed, so by
  default a pod that restarts while the API is unreachable will not bind and
  syncs stop. Set `cache.enabled=true` to start from the last response it saw
  instead; it keeps retrying and switches to live secrets as soon as the API
  answers. Only ciphertext is stored, so the volume is no more sensitive than
  the token Secret already in the pod — but a revoked token keeps working until
  `cache.maxAge` elapses. Use a PVC for `cache.volume` if you want it to survive
  rescheduling onto another node.
- **Whole-environment pulls.** ESO's webhook provider fetches one key at a time
  (the sidecar caches, so it's cheap). List keys in `data[]`, or use a
  `target.template` against the sidecar's `/v1/secrets` map.
