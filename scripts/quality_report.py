"""Export real Flutter JSON test results, JUnit, LCOV and browsable coverage.
Run after flutter test --coverage --reporter=json > docs/quality/tests.jsonl.
No test counts or pass statuses are inferred from source-code searches.
"""
from collections import Counter
from datetime import datetime, timezone
from html import escape
from pathlib import Path
import json
import shutil
import sys
import xml.etree.ElementTree as ET
from source_fingerprint import source_identity

root = Path(__file__).resolve().parents[1]
report = root / 'docs/quality'
events = [json.loads(line) for line in (report / 'tests.jsonl').read_text().splitlines() if line.startswith('{')]
suites = {e['suite']['id']: e['suite']['path'] for e in events if e['type'] == 'suite'}
starts = {e['test']['id']: e['test'] for e in events if e['type'] == 'testStart'}
results = []
for event in events:
    if event['type'] != 'testDone' or event.get('hidden', False):
        continue
    test = starts[event['testID']]
    path = suites.get(test['suiteID'], test.get('url', ''))
    if '/test/' not in path:
        continue
    path = 'test/' + path.split('/test/', 1)[1]
    results.append({'name': test['name'], 'path': path, 'result': event['result'], 'skipped': event.get('skipped', False)})
done = [e for e in events if e['type'] == 'done']
success = bool(done and done[-1]['success'] and results)

files = []
current = None
for line in (root / 'coverage/lcov.info').read_text().splitlines():
    if line.startswith('SF:'):
        name = line[3:]
        if '/lib/' in name: name = 'lib/' + name.split('/lib/', 1)[1]
        current = {'path': name, 'hits': {}}
        files.append(current)
    elif current is not None and line.startswith('DA:'):
        number, hits, *_ = line[3:].split(',')
        current['hits'][int(number)] = int(hits)
for item in files:
    item['covered'] = sum(hit > 0 for hit in item['hits'].values())
    item['lines'] = len(item['hits'])
business = [f for f in files if f['path'].startswith(('lib/domain/', 'lib/data/', 'lib/state/'))]
covered = sum(f['covered'] for f in business)
lines = sum(f['lines'] for f in business)
percent = round(100 * covered / lines, 2) if lines else 0
counts = Counter('unit' if r['path'].startswith('test/unit/') else 'widget' for r in results)
hashes, source_sha = source_identity(root)
summary = {'generated_utc': datetime.now(timezone.utc).isoformat(), 'success': success,
    'counts': dict(counts), 'passed': sum(r['result'] == 'success' and not r['skipped'] for r in results),
    'skipped': sum(r['skipped'] for r in results), 'business_coverage': {'covered': covered, 'lines': lines, 'percent': percent},
    'source_sha256': source_sha,
    'source_files': hashes, 'tests': results}
(report / 'summary.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2) + '\n')
shutil.copyfile(root / 'coverage/lcov.info', report / 'lcov.info')
junit = ET.Element('testsuite', name='FocusFlow', tests=str(len(results)), failures=str(sum(r['result'] != 'success' for r in results)), skipped=str(summary['skipped']))
for r in results:
    case = ET.SubElement(junit, 'testcase', name=r['name'], classname=r['path'])
    if r['skipped']: ET.SubElement(case, 'skipped')
    elif r['result'] != 'success': ET.SubElement(case, 'failure').text = 'See tests.jsonl for the complete Flutter error.'
ET.ElementTree(junit).write(report / 'junit.xml', encoding='utf-8', xml_declaration=True)
md = ['# Résultats automatisés', '', f"Générés le {summary['generated_utc']}. Source SHA-256 : `{summary['source_sha256']}`.", '',
      f"- Exécution terminée avec succès : **{success}**.", f"- Tests unitaires : **{counts['unit']}** ; widgets : **{counts['widget']}**.",
      f"- Réussis : **{summary['passed']}** ; ignorés : **{summary['skipped']}**.",
      f'- Couverture métier : **{covered}/{lines} lignes ({percent} %)**.', '',
      '[Résultats JSON](summary.json) · [Flux Flutter brut](tests.jsonl) · [JUnit](junit.xml) · [LCOV](lcov.info) · [Couverture HTML](coverage.html)', '',
      '| Fichier | Lignes couvertes | Couverture |', '| --- | ---: | ---: |']
for f in business:
    md.append(f"| `{f['path']}` | {f['covered']}/{f['lines']} | {100*f['covered']/f['lines'] if f['lines'] else 100:.1f} % |")
(report / 'SUMMARY.md').write_text('\n'.join(md) + '\n')
html = ['<!doctype html><html lang="fr"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>FocusFlow — couverture réelle</title>',
 '<style>body{font:16px system-ui;max-width:1100px;margin:40px auto;padding:0 20px;color:#17261e}pre{overflow:auto;background:#f5f5f5;padding:16px;line-height:1.6}.miss{background:#ffe1de;color:#701510}.hit{background:#e4f3e7;color:#173c24}summary{cursor:pointer;padding:12px}a{color:#254d3f}</style>',
 f'<h1>Couverture FocusFlow</h1><p>{covered}/{lines} lignes métier ({percent} %). Généré à partir du fichier LCOV, hors traductions générées.</p>']
for f in files:
    source = root / f['path']
    if not source.is_file() or '/l10n/' in f['path']: continue
    html.append(f"<details><summary>{escape(f['path'])} — {f['covered']}/{f['lines']} lignes</summary><pre>")
    for number, line in enumerate(source.read_text().splitlines(), 1):
        cls = 'hit' if f['hits'].get(number, 0) > 0 else 'miss' if number in f['hits'] else ''
        html.append(f'<span class="{cls}">{number:4} {escape(line)}</span>\n')
    html.append('</pre></details>')
html.append('</html>')
(report / 'coverage.html').write_text(''.join(html))
print('\n'.join(md[:10]))
if not success or counts['unit'] < 10 or counts['widget'] < 5 or summary['skipped'] or percent < 90:
    sys.exit('Quality gate failed. Inspect docs/quality/tests.jsonl and coverage.html.')
