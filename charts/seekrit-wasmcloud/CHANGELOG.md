# Changelog

## [0.4.0](https://github.com/mileszim/seekrit/compare/chart-wasmcloud-v0.3.1...chart-wasmcloud-v0.4.0) (2026-09-14)


### Features

* **charts:** publish a real Helm repository at charts.seekrit.dev ([#408](https://github.com/mileszim/seekrit/issues/408)) ([46e31a0](https://github.com/mileszim/seekrit/commit/46e31a0ccd22a2a9ada1e344c0d8dd59845704b6))
* **wasmcloud:** seekrit as a wasmCloud secrets backend ([#404](https://github.com/mileszim/seekrit/issues/404)) ([d688f35](https://github.com/mileszim/seekrit/commit/d688f35e01991054b9b7964b16d27034604ff4b5))


### Bug Fixes

* **charts:** repair the release-please wiring that keeps chart appVersions current ([#410](https://github.com/mileszim/seekrit/issues/410)) ([bdca2c7](https://github.com/mileszim/seekrit/commit/bdca2c7d4d1dcd1bf38abba35ae6e560e5572487))


### Miscellaneous Chores

* release main ([#407](https://github.com/mileszim/seekrit/issues/407)) ([0fa7059](https://github.com/mileszim/seekrit/commit/0fa70591713e2a6014b44a72df13c79f482a40ab))
* release main ([#409](https://github.com/mileszim/seekrit/issues/409)) ([502eb33](https://github.com/mileszim/seekrit/commit/502eb339c8a6b383fa6bf617ae974eba8e971047))

## [0.3.1](https://github.com/mileszim/seekrit/compare/chart-wasmcloud-v0.3.0...chart-wasmcloud-v0.3.1) (2026-09-14)


### Bug Fixes

* **charts:** pin `appVersion` to the released wasmcloud-secrets (0.1.0 -> 0.2.0). The chart rendered `seekritdev/wasmcloud-secrets:0.1.0`, an image tag that was never published to any registry, so every install landed in ImagePullBackOff.

## [0.3.0](https://github.com/mileszim/seekrit/compare/chart-wasmcloud-v0.2.0...chart-wasmcloud-v0.3.0) (2026-09-14)


### Features

* **charts:** publish a real Helm repository at charts.seekrit.dev ([#408](https://github.com/mileszim/seekrit/issues/408)) ([46e31a0](https://github.com/mileszim/seekrit/commit/46e31a0ccd22a2a9ada1e344c0d8dd59845704b6))

## [0.2.0](https://github.com/mileszim/seekrit/compare/chart-wasmcloud-v0.1.0...chart-wasmcloud-v0.2.0) (2026-09-14)


### Features

* **wasmcloud:** seekrit as a wasmCloud secrets backend ([#404](https://github.com/mileszim/seekrit/issues/404)) ([d688f35](https://github.com/mileszim/seekrit/commit/d688f35e01991054b9b7964b16d27034604ff4b5))
