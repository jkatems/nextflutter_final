#!/usr/bin/env bash
set -euo pipefail
: "${CHROMEDRIVER:=chromedriver}"
: "${CHROME_BINARY:=google-chrome}"
: "${BROWSER_DIMENSION:=1440x1080}"
: "${EVIDENCE_DIR:=docs/quality}"
mkdir -p "$EVIDENCE_DIR"
"$CHROMEDRIVER" --port=4444 > /tmp/focusflow-chromedriver.log 2>&1 &
focusflow_driver_pid=$!
trap 'kill "$focusflow_driver_pid" 2>/dev/null || true' EXIT
ready=false
for i in $(seq 1 30); do
  if ! kill -0 "$focusflow_driver_pid" 2>/dev/null; then cat /tmp/focusflow-chromedriver.log; exit 1; fi
  if curl -fsS http://localhost:4444/status > /dev/null; then ready=true; break; fi
  sleep 1
done
if [ "$ready" != true ]; then cat /tmp/focusflow-chromedriver.log; exit 1; fi
flutter drive --no-pub --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d web-server --browser-name=chrome \
  --chrome-binary="$CHROME_BINARY" --headless \
  --browser-dimension="$BROWSER_DIMENSION" --dart-define=SCREENSHOTS=true 2>&1 | tee "$EVIDENCE_DIR/integration-web.txt"
