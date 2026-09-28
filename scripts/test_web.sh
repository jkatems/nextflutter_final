#!/usr/bin/env bash
set -euo pipefail
: "${CHROMEDRIVER:=chromedriver}"
: "${CHROME_BINARY:=google-chrome}"
: "${BROWSER_DIMENSION:=1440x1080}"
"$CHROMEDRIVER" --port=4444 > /tmp/focusflow-chromedriver.log 2>&1 &
focusflow_driver_pid=$!
trap 'kill "$focusflow_driver_pid" 2>/dev/null || true' EXIT
for i in $(seq 1 30); do
  if curl -fsS http://localhost:4444/status > /dev/null; then break; fi
  sleep 1
done
flutter drive --no-pub --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d web-server --browser-name=chrome \
  --chrome-binary="$CHROME_BINARY" --headless \
  --browser-dimension="$BROWSER_DIMENSION" --dart-define=SCREENSHOTS=true
