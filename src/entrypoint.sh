#!/bin/sh
# ===========================================================================
# Alertmanager entrypoint for a non-root container (TOS 7 requirement).
#
# The image ships no configuration and exits without one. This wrapper writes a
# minimal routing config on the first start so the UI comes up, and keeps both
# the config and the notification state on the mounted volume.
# ===========================================================================
set -e
set -u

DATA=/alertmanager
mkdir -p "$DATA" 2>/dev/null || true

if ! ( : > "$DATA/.write-test" ) 2>/dev/null; then
  echo "alertmanager: $DATA is not writable by uid $(id -u)" >&2
  exit 1
fi
rm -f "$DATA/.write-test"

if [ ! -s "$DATA/alertmanager.yml" ]; then
  cat > "$DATA/alertmanager.yml" <<'YAML'
# Alertmanager configuration - edit and restart the app.
# Receivers: https://prometheus.io/docs/alerting/latest/configuration/
route:
  receiver: default
  group_by: [alertname]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h

receivers:
  - name: default
YAML
  echo "alertmanager: wrote a minimal config to $DATA/alertmanager.yml"
fi

exec /bin/alertmanager \
  --config.file="$DATA/alertmanager.yml" \
  --storage.path="$DATA"
