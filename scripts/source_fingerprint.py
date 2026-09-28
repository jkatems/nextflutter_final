"""Identity of the Dart sources and locked dependency inputs that were tested."""
from hashlib import sha256
from pathlib import Path
import json


def source_identity(root: Path):
    files = sorted(p for folder in ('lib', 'test', 'integration_test', 'test_driver')
                   for p in (root / folder).rglob('*.dart'))
    files += [root / 'pubspec.yaml', root / 'pubspec.lock']
    hashes = {str(p.relative_to(root)): sha256(p.read_bytes()).hexdigest() for p in files}
    return hashes, sha256(json.dumps(hashes, sort_keys=True).encode()).hexdigest()
