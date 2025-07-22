"""
Batch rescaling in GIMP:
Put this file in(/Applications/GIMP.app/Contents/Resources/lib/gimp/2.0/plug-ins/python-console/batch_rescale.py)
Put to be scaled images into a folder called "org" inside the output_folder

Filters -> Python-Fu -> Console
import batch_rescale
output_folder = "/Users/username/src/garmin/hal-9000/python-helpers/garmin-pics"
batch_rescale.resize_images(output_folder)

"""

from gimpfu import *
import os

sizes = [208, 218, 240, 260, 280, 360, 390, 416, 454]
# launcher_sizes = [30, 35, 36, 40, 54, 56, 60, 61, 65, 70, 77]

def resize_images(output_folder):
    input_folder = os.path.join(output_folder, "org")
    for size in sizes:
        output_dir = "{}/resources-round-{}x{}".format(output_folder, size, size)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

    for filename in os.listdir(input_folder):
        if filename.endswith(".png"):
            input_path = os.path.join(input_folder, filename)
            image = pdb.gimp_file_load(input_path, input_path)
            drawable = pdb.gimp_image_get_active_layer(image)
            for size in sizes:
                output_dir = "{}/resources-round-{}x{}".format(output_folder, size, size)
                output_path = os.path.join(output_dir, filename)
                # Duplicate image to avoid modifying the original
                resized_image = pdb.gimp_image_duplicate(image)
                resized_drawable = pdb.gimp_image_get_active_layer(resized_image)
                pdb.gimp_image_scale(resized_image, size, size)
                pdb.file_png_save_defaults(resized_image, resized_drawable, output_path, output_path)
                pdb.gimp_image_delete(resized_image)
            pdb.gimp_image_delete(image)

    print("Batch resizing completed.")

