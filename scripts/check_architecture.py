"""Fail when inner layers import UI/storage implementations or widgets know state."""
from pathlib import Path
import re

for folder, forbidden in {
    'domain': ('/ui/', '/state/', '/data/', 'package:flutter/', 'package:shared_preferences/'),
    'state': ('/ui/', '/data/', 'package:shared_preferences/'),
    'ui/widgets': ('/state/', '/data/', '/screens/', '/navigation.dart'),
}.items():
    for source in Path('lib', folder).rglob('*.dart'):
        for uri in re.findall(r"(?:import|export)\s+['\"]([^'\"]+)", source.read_text()):
            target = uri if uri.startswith('package:') else str((source.parent / uri).resolve())
            assert not any(item in target for item in forbidden), f'{source}: forbidden dependency {uri}'
print('Architecture boundaries: OK')
