"""Package reviewable sources, tests and evidence, never just compiled web output."""
from pathlib import Path
from hashlib import sha256
import json
import subprocess
import zipfile
from source_fingerprint import source_identity

root = Path(__file__).resolve().parents[1]
# Include uncommitted new files, honor ignores (secrets, build caches, dist).
if (root / '.git').exists():
    paths = subprocess.check_output(['git', 'ls-files', '--cached', '--others', '--exclude-standard', '-z'], cwd=root).decode().split('\0')
else:
    # A submitted archive intentionally contains no Git history or credentials.
    paths = list(json.loads((root / 'SUBMISSION_MANIFEST.json').read_text())['files'])
files = sorted({p for p in paths if p and (root / p).is_file() and not (root / p).is_symlink()})
required = ['README.md', 'CHANGELOG.md', '.github/workflows/ci.yml', 'pubspec.lock',
    'test/unit/task_test.dart', 'test/widgets/accessibility_test.dart', 'integration_test/app_test.dart',
    'integration_test/performance_test.dart', 'docs/quality/summary.json', 'docs/quality/lcov.info',
    'docs/ACCESSIBILITY.md', 'docs/ARCHITECTURE.md', 'docs/REQUIREMENTS.md',
    'docs/quality/junit.xml', 'docs/quality/coverage.html', 'docs/quality/tests.jsonl',
    'docs/quality/analyze.txt', 'docs/quality/integration-web.txt', 'docs/quality/localizations.json',
    'docs/benchmarks/linux-profile.json', 'docs/benchmarks/linux-profile-metadata.json']
quality = json.loads((root / 'docs/quality/summary.json').read_text())
assert quality['success'], 'Quality report is not successful'
assert source_identity(root)[1] == quality['source_sha256'], 'Sources changed since testing: regenerate evidence'
missing = set(required) - set(files)
assert not missing, f'Missing mandatory evidence: {sorted(missing)}'
for path in files:
    assert not path.endswith(('.jks', '.keystore')) and Path(path).name not in ('key.properties', 'local.properties', '.env'), f'Sensitive file: {path}'
version = next(line.split(':', 1)[1].strip().split('+')[0] for line in (root / 'pubspec.yaml').read_text().splitlines() if line.startswith('version:'))
out = root / f'dist/focusflow-source-{version}.zip'
out.parent.mkdir(exist_ok=True)
manifest = {'version': version, 'purpose': 'Complete source submission with tests and evidence',
    'files': {p: sha256((root / p).read_bytes()).hexdigest() for p in files}}
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in files: archive.write(root / path, f'focusflow/{path}')
    archive.writestr('focusflow/SUBMISSION_MANIFEST.json', json.dumps(manifest, indent=2))
with zipfile.ZipFile(out) as archive:
    assert archive.testzip() is None
    assert all('focusflow/' + p in archive.namelist() for p in required)
print(f'{out}: {len(files)} files, {out.stat().st_size / 1024 / 1024:.1f} MiB; manifest and required tests verified.')
