"""
Batch rescaling in GIMP:
Put this file in(/Applications/GIMP.app/Contents/Resources/lib/gimp/2.0/plug-ins/python-console/batch_rescale.py)
Filters -> Python-Fu -> Console
"""

from gimpfu import *
import math

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def draw_hal(circle_colours, distance_between_circles):
    # Compute the size of the largest circle
    total_radius = sum(distance_between_circles)
    image_size = total_radius * 2 + 10

    img = gimp.Image(image_size, image_size, RGB)
    layer = gimp.Layer(img, "hal_layer", image_size, image_size, RGB_IMAGE, 100, NORMAL_MODE)
    img.add_layer(layer, 0)

    # black background
    pdb.gimp_context_set_background((0, 0, 0))
    pdb.gimp_drawable_fill(layer, BACKGROUND_FILL)

    # Draw each circle
    cx = cy = image_size // 2
    radius = total_radius
    for color_hex, shrink in zip(circle_colours, distance_between_circles):
        r, g, b = hex_to_rgb(color_hex)
        pdb.gimp_context_set_foreground((r, g, b))

        left = cx - radius
        top = cy - radius
        size = radius * 2

        pdb.gimp_image_select_ellipse(img, CHANNEL_OP_REPLACE, left, top, size, size)
        pdb.gimp_edit_fill(layer, FOREGROUND_FILL)
        pdb.gimp_selection_none(img)

        radius -= shrink

    gimp.Display(img)
    gimp.displays_flush()

# New version (less rim)
"""
import hal_gimp
circle_colours = [ "000000", "aaaaaa", "ffffff", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]

distance_between_circles = [5, 20, 5, 150, 75, 15, 50,  30,1, 30, 15, 25, 10]
hal_gimp.draw_hal(circle_colours, distance_between_circles)
"""

"""
import hal_gimp
circle_colours = [ "000000", "aaaaaa", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]

distance_between_circles = [5, 7, 168, 75, 15, 50,  30,1, 30, 15, 25, 10]
hal_gimp.draw_hal(circle_colours, distance_between_circles)
"""

"""
pulsing

#1
circle_colours = [ "000000", "aaaaaa", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]
distance_between_circles = [5, 7, 168, 60, 15, 60, 35,1, 30, 15, 25, 10]

#2
circle_colours = [ "000000", "aaaaaa",  "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]
distance_between_circles = [5, 7, 168, 35, 25, 70, 40,1, 30, 15, 25, 10]

#3
circle_colours = [ "000000", "aaaaaa", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]
distance_between_circles = [5, 7, 118, 60, 35, 80, 45,1, 30, 15, 25, 10]
"""

# Old version (proper rim)
"""
import hal_gimp
circle_colours = [ "000000", "aaaaaa","ffffff", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]

distance_between_circles = [5, 20, 5, 150, 75, 15, 50,  30,1, 30, 15, 25, 10]
hal_gimp.draw_hal(circle_colours, distance_between_circles)
"""

"""
pulsing

#1
circle_colours = [ "000000", "aaaaaa", "ffffff", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]
distance_between_circles = [5, 20, 5, 150, 60, 15, 60, 35,1, 30, 15, 25, 10]

#2
circle_colours = [ "000000", "aaaaaa", "ffffff", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]
distance_between_circles = [5, 20, 5, 150, 35, 25, 70, 40,1, 30, 15, 25, 10]

#3
circle_colours = [ "000000", "aaaaaa", "ffffff", "000000", "550000", "aa0000", "ff0000", "ff5500", "ffffff",  "ffaa00", "ffaa55",  "ffffaa",   "ffffff" ]
distance_between_circles = [5, 20, 5, 100, 60, 35, 80, 45,1, 30, 15, 25, 10]

distance_between_circles = [5, 20, 5, 125, 35, 35, 80, 45,1, 30, 15, 25, 10]
"""