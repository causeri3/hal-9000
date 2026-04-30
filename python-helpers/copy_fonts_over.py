from pathlib import Path
import shutil
import os

# Works in IDE
try:
    BASE_DIR = Path(__file__).resolve().parent
except NameError:
    BASE_DIR = Path(os.getcwd())

font_sizes = [17, 17, 19, 21, 22, 29, 31, 33, 36]
sizes = [208, 218, 240, 260, 280, 360, 390, 416, 454]

src_base = BASE_DIR / "output_fonts"
dest_base = BASE_DIR / "resources-round"

for font_size, size in zip(font_sizes, sizes):
    src = src_base / str(font_size)
    dest = dest_base / f"{size}x{size}" / "fonts"

    print(f"Copying {src} -> {dest}")

    dest.mkdir(parents=True, exist_ok=True)

    for item in src.iterdir():
        target = dest / item.name
        if item.is_dir():
            shutil.copytree(item, target, dirs_exist_ok=True)
        else:
            shutil.copy2(item, target)