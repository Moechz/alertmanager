# Changelog

All notable user-visible changes to the Alertmanager TOS application package.

## 0.35.0-1 — 2026-11-15

### Added
- First release. Alertmanager (`prom/alertmanager:v0.35.0`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8162 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/alertmanagerdocker/`.
