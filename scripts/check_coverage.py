"""Check business-layer LCOV coverage without third-party dependencies."""
from pathlib import Path
import sys

lines = covered = 0
include = False
for line in Path('coverage/lcov.info').read_text().splitlines():
    if line.startswith('SF:'):
        include = any(f'lib/{folder}/' in line for folder in ('domain', 'data', 'state'))
    elif include and line.startswith('DA:'):
        lines += 1
        covered += int(line.split(',')[1]) > 0
ratio = covered / lines if lines else 0
print(f'Business coverage: {covered}/{lines} lines ({ratio:.1%})')
if ratio < .90:
    sys.exit('Required business coverage: 90%')
