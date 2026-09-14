# Changelog

## [0.7.0](https://github.com/mileszim/seekrit/compare/chart-v0.6.1...chart-v0.7.0) (2026-09-14)


### Features

* **charts:** publish a real Helm repository at charts.seekrit.dev ([#408](https://github.com/mileszim/seekrit/issues/408)) ([46e31a0](https://github.com/mileszim/seekrit/commit/46e31a0ccd22a2a9ada1e344c0d8dd59845704b6))
* **k8s:** External Secrets Operator integration (sidecar + Helm chart) ([#85](https://github.com/mileszim/seekrit/issues/85)) ([7106968](https://github.com/mileszim/seekrit/commit/710696885c29e940b2d1ceccff5e36b113057d04))
* OpenTelemetry for the self-hosted services ([#187](https://github.com/mileszim/seekrit/issues/187)) ([ead4ac6](https://github.com/mileszim/seekrit/commit/ead4ac6492e2e032e0ad0c25f0fbbf7830397a8a))
* opt-in last-known-good cache for the integration tools ([#192](https://github.com/mileszim/seekrit/issues/192)) ([c14eeaa](https://github.com/mileszim/seekrit/commit/c14eeaa3c01f9d397e71033ecc13d7e747e0ef25))


### Bug Fixes

* **charts:** repair the release-please wiring that keeps chart appVersions current ([#410](https://github.com/mileszim/seekrit/issues/410)) ([bdca2c7](https://github.com/mileszim/seekrit/commit/bdca2c7d4d1dcd1bf38abba35ae6e560e5572487))
* **k8s:** fix seekrit-eso ESO integration + auto-sync chart versioning ([#100](https://github.com/mileszim/seekrit/issues/100)) ([a690071](https://github.com/mileszim/seekrit/commit/a6900714dad0f8c6d1a4ab5fccb8a096ee803114))


### Miscellaneous Chores

* release main ([#101](https://github.com/mileszim/seekrit/issues/101)) ([a6f2acc](https://github.com/mileszim/seekrit/commit/a6f2acc09eafe41cb9e3d2d5a07e15dfe5716a53))
* release main ([#189](https://github.com/mileszim/seekrit/issues/189)) ([1f1c917](https://github.com/mileszim/seekrit/commit/1f1c9176670fe538cb8b4c3995c0bdef2abd9b6a))
* release main ([#193](https://github.com/mileszim/seekrit/issues/193)) ([13dec0a](https://github.com/mileszim/seekrit/commit/13dec0a3e7f68694a885f4715bbedcbe1be02783))
* release main ([#409](https://github.com/mileszim/seekrit/issues/409)) ([502eb33](https://github.com/mileszim/seekrit/commit/502eb339c8a6b383fa6bf617ae974eba8e971047))

## [0.6.1](https://github.com/mileszim/seekrit/compare/chart-v0.6.0...chart-v0.6.1) (2026-09-14)


### Bug Fixes

* **charts:** pin `appVersion` to the released sdk-server (0.2.0 -> 0.7.2). The `extra-files` updater that should have kept it current addressed a path that does not exist, so it had never run.

## [0.6.0](https://github.com/mileszim/seekrit/compare/chart-v0.5.0...chart-v0.6.0) (2026-09-14)


### Features

* **charts:** publish a real Helm repository at charts.seekrit.dev ([#408](https://github.com/mileszim/seekrit/issues/408)) ([46e31a0](https://github.com/mileszim/seekrit/commit/46e31a0ccd22a2a9ada1e344c0d8dd59845704b6))

## [0.5.0](https://github.com/mileszim/seekrit/compare/chart-v0.4.0...chart-v0.5.0) (2026-08-15)


### Features

* opt-in last-known-good cache for the integration tools ([#192](https://github.com/mileszim/seekrit/issues/192)) ([c14eeaa](https://github.com/mileszim/seekrit/commit/c14eeaa3c01f9d397e71033ecc13d7e747e0ef25))

## [0.4.0](https://github.com/mileszim/seekrit/compare/chart-v0.3.0...chart-v0.4.0) (2026-08-15)


### Features

* OpenTelemetry for the self-hosted services ([#187](https://github.com/mileszim/seekrit/issues/187)) ([ead4ac6](https://github.com/mileszim/seekrit/commit/ead4ac6492e2e032e0ad0c25f0fbbf7830397a8a))

## [0.3.0](https://github.com/mileszim/seekrit/compare/chart-v0.2.0...chart-v0.3.0) (2026-07-19)


### Features

* **k8s:** External Secrets Operator integration (sidecar + Helm chart) ([#85](https://github.com/mileszim/seekrit/issues/85)) ([7106968](https://github.com/mileszim/seekrit/commit/710696885c29e940b2d1ceccff5e36b113057d04))


### Bug Fixes

* **k8s:** fix seekrit-eso ESO integration + auto-sync chart versioning ([#100](https://github.com/mileszim/seekrit/issues/100)) ([a690071](https://github.com/mileszim/seekrit/commit/a6900714dad0f8c6d1a4ab5fccb8a096ee803114))
