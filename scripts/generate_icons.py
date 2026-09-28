"""Render the original FocusFlow geometric sprout into platform icon sizes.
Development-only dependency: Pillow. Does not edit photos.
"""
from pathlib import Path
import json
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[1]

def icon(path, size):
    scale = 4
    image = Image.new('RGB', (size * scale, size * scale), '#254d3f')
    d = ImageDraw.Draw(image)
    def poly(points, fill):
        d.polygon([(int(x * size * scale), int(y * size * scale)) for x, y in points], fill=fill)
    poly([(.5,.2),(.38,.38),(.4,.49),(.5,.58),(.6,.49),(.62,.38)], '#dde9be')
    poly([(.22,.43),(.23,.59),(.32,.73),(.5,.81),(.5,.62),(.39,.51)], '#f6f7f2')
    poly([(.78,.43),(.77,.59),(.68,.73),(.5,.81),(.5,.62),(.61,.51)], '#b3ceb5')
    target = root / path
    target.parent.mkdir(parents=True, exist_ok=True)
    image.resize((size, size), Image.Resampling.LANCZOS).save(target)

icon('web/favicon.png', 32)
for size in (192, 512):
    for prefix in ('Icon-', 'Icon-maskable-'):
        icon(f'web/icons/{prefix}{size}.png', size)
for density, size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    icon(f'android/app/src/main/res/mipmap-{density}/ic_launcher.png', size)
base = Path('ios/Runner/Assets.xcassets/AppIcon.appiconset')
for item in json.loads((root / base / 'Contents.json').read_text())['images']:
    if 'filename' in item:
        size = round(float(item['size'].split('x')[0]) * float(item['scale'].replace('x','')))
        icon(base / item['filename'], size)
print('Platform icons rendered.')
