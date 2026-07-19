# helm-charts

Helm charts for [seekrit](https://seekrit.dev).

This repo is a **read-only mirror**, published from seekrit's monorepo so the
chart is auditable before you install it into a cluster. Don't commit directly
here — it'll be overwritten on the next sync.

## Charts

- [`seekrit-eso`](charts/seekrit-eso) — sync seekrit secrets into Kubernetes via
  the External Secrets Operator, on stock ESO. See its
  [README](charts/seekrit-eso/README.md) for values and install instructions,
  and the [`seekrit-sdk-server`](https://github.com/seekritdev/seekrit-sdk-server)
  repo for the sidecar it deploys. Full walkthrough:
  [Kubernetes guide](https://seekrit.dev/docs/guides/kubernetes).

## License

MIT — see [LICENSE](LICENSE).
