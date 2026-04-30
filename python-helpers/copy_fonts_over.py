from pathlib import Path
import shutil
import os

try:
    SCRIPT_DIR = Path(__file__).resolve().parent
except NameError:
    SCRIPT_DIR = Path(os.getcwd())

BASE_DIR = SCRIPT_DIR.parent

font_sizes = [17, 17, 19, 21, 22, 29, 31, 33, 36]
sizes = [208, 218, 240, 260, 280, 360, 390, 416, 454]

src_base = SCRIPT_DIR / "output_fonts"

for font_size, size in zip(font_sizes, sizes):
    src = src_base / str(font_size)

    if size == 240:
        base_name = f"resources-rectangle-{size}x{size}"
    else:
        base_name = f"resources-round-{size}x{size}"

    dest = BASE_DIR / base_name / "fonts"

    print(f"Copying {src} -> {dest}")

    dest.mkdir(parents=True, exist_ok=True)

    for item in src.iterdir():
        target = dest / item.name
        if item.is_dir():
            shutil.copytree(item, target, dirs_exist_ok=True)
        else:
            shutil.copy2(item, target)
