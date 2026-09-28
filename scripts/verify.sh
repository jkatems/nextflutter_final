#!/usr/bin/env bash
set -euo pipefail
flutter pub get --enforce-lockfile
flutter gen-l10n
mkdir -p docs/quality
dart format --output=none --set-exit-if-changed lib test integration_test test_driver
python3 scripts/check_architecture.py
python3 scripts/check_localizations.py
flutter analyze --no-pub --fatal-infos | tee docs/quality/analyze.txt
if ! flutter test --no-pub --coverage --reporter=json > docs/quality/tests.jsonl; then
  python3 scripts/quality_report.py
  exit 1
fi
python3 scripts/check_coverage.py
python3 scripts/quality_report.py
flutter build web --release --no-pub --no-web-resources-cdn | tee docs/quality/build-web.txt
