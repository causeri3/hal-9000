import os
from PIL import Image, ImageDraw, ImageFont

font_path = "/Users/username/Downloads/telegrama/outline font/telegrama_render.otf"

output_dir = "output_fonts"

font_name = os.path.splitext(os.path.basename(font_path))[0]
sizes = [208, 218, 240, 260, 280, 360, 390, 416, 454]
font_sizes = [round(display_size * 0.08) for display_size in sizes]
fields_no = 17
max_curve = 292.5
min_curve = 67.5
step_size = (min_curve / ((fields_no-1)/2))
angles_min = [min_curve - i * step_size for i in range(int((fields_no-1)/2))]
angles_max = [max_curve + i * step_size for i in range(int((fields_no-1)/2))]
angles = angles_min + [360] + angles_max[::-1]

characters = "0123456789:|"


os.makedirs(output_dir, exist_ok=True)


def measure_biggest_char(font, size, angle):
    max_width = 0
    max_height = 0
    rotated_chars = []


    for char in characters:
        img = Image.new("RGBA", (size * 4, size * 4), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        draw.text((img.width // 2, img.height // 2), char, font=font, fill=(255, 255, 255, 255), anchor="mm")

        rotated = img.rotate(angle, resample=Image.BICUBIC, expand=True)
        #rotated_chars.append((char, rotated))
        cropped = rotated.crop(rotated.getbbox())
        rotated_chars.append((char, cropped))
        #cropped.show()
        print(cropped.width)
        print(cropped.height)

        max_width = max(max_width, cropped.width)
        max_height = max(max_height, cropped.height)
    return rotated_chars, max_width, max_height

#max_width, max_height = measure_biggest_char(size)

def create_font_variant(angle, size, idx):
    font = ImageFont.truetype(font_path, size)
    rotated_chars, max_width, max_height = measure_biggest_char(font, size, angle)
    char_images = []
    metadata = []

    for char, rotated in rotated_chars:
        canvas = Image.new("RGBA", (max_width, max_height), (0, 0, 0, 0))
        offset = (
            (max_width - rotated.width) // 2,
            (max_height - rotated.height) // 2
        )
        #print(offset)
        canvas.paste(rotated, offset, rotated)
        #canvas.paste(rotated, (max_width, max_height))
        char_images.append((char, canvas))

    # bitmap
    total_width = sum(img.size[0] + 2 for _, img in char_images)
    max_height = max(img.size[1] for _, img in char_images)
    sheet = Image.new("RGBA", (total_width, max_height), (0, 0, 0, 0))

    x = 0
    for char, img in char_images:
        sheet.paste(img, (x, 0), img)
        metadata.append({
            "id": ord(char),
            "x": x,
            "y": 0,
            "width": img.width,
            "height": img.height,
            "xoffset": 0,
            "yoffset": 0,
            "xadvance": img.width + 2,
        })
        x += img.width + 2

    png_filename = f"font{idx}.png"
    sheet.save(os.path.join(output_dir, str(size), png_filename))

    # fnt file
    fnt_filename = png_filename.replace(".png", ".fnt")
    with open(os.path.join(output_dir, str(size), fnt_filename), "w", encoding="utf-8") as f:
        f.write(f'info face="{font_name}" size={size} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=1,1,1,1 spacing=1,1\n')
        f.write(f'common lineHeight={max_height} base=0 scaleW={sheet.width} scaleH={sheet.height} pages=1 packed=0\n')
        f.write(f'page id=0 file="{png_filename}"\n')
        f.write(f'chars count={len(metadata)}\n')
        for m in metadata:
            f.write(
                f'char id={m["id"]} x={m["x"]} y={m["y"]} width={m["width"]} height={m["height"]} '
                f'xoffset={m["xoffset"]} yoffset={m["yoffset"]} xadvance={m["xadvance"]} '
                f'page=0 chnl=0\n'
            )

for size in font_sizes:
    os.makedirs(os.path.join(output_dir, str(size)), exist_ok=True)
    for idx, angle in enumerate(angles):
        print(f"Generating: size={size}, angle={angle}")
        create_font_variant(angle, size, idx)


