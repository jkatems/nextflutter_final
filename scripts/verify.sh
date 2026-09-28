#!/usr/bin/env bash
set -euo pipefail
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed lib test integration_test test_driver
flutter analyze --fatal-infos
flutter test --coverage
python3 scripts/check_coverage.py
flutter build web --release --no-web-resources-cdn
