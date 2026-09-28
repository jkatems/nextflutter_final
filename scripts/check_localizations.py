"""Verify that both shipped ARB catalogs contain the complete UI vocabulary."""
import json
import re
from pathlib import Path

root = Path(__file__).resolve().parents[1]
catalogs = {}
for locale in ('fr', 'en'):
    path = root / f'lib/l10n/app_{locale}.arb'
    data = json.loads(path.read_text())
    assert data['@@locale'] == locale, f'Incorrect locale: {path}'
    messages = {key: value for key, value in data.items() if not key.startswith('@')}
    assert messages and all(isinstance(value, str) and value.strip() for value in messages.values()), f'Empty translation: {path}'
    catalogs[locale] = messages
assert catalogs['fr'].keys() == catalogs['en'].keys(), 'FR/EN translation keys differ'
for key, french in catalogs['fr'].items():
    # Includes ICU arguments (count) and simple interpolations (title).
    arguments = lambda value: set(re.findall(r'\{([A-Za-z_]\w*)\s*[,}]', value))
    assert arguments(french) == arguments(catalogs['en'][key]), f'Argument mismatch: {key}'
report = {'success': True, 'locales': ['fr', 'en'],
          'messages_per_locale': len(catalogs['fr']),
          'checks': ['locale identifiers', 'identical keys', 'nonempty translations', 'matching ICU arguments'],
          'runtime_evidence': 'test/widgets/app_test.dart and test/widgets/accessibility_test.dart'}
output = root / 'docs/quality/localizations.json'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, ensure_ascii=False))
