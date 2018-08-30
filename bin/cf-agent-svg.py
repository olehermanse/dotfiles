#!/usr/bin/env python3
import sys

if len(sys.argv) != 2:
    print("Usage:   cf-agent-svg.py <circle_radius>")
    print("Example: cf-agent-svg.py 32")
    sys.exit(1)

radius = int(sys.argv[1])

cfengine_blue = "#0071a6"
cfengine_orange = "#f5821f"

diameter = radius * 2
width = diameter * 12
height = diameter * 12


class Circle:
    """An SVG Circle with x, y, radius and color"""

    def __init__(self, x, y, r=radius, c=cfengine_blue):
        self.x = x * r * 2 + r
        self.y = y * r * 2 + r
        self.r = r
        self.c = c

    def __str__(self):
        return '<circle cx="{}" cy="{}" r="{}" fill="{}" />'.format(
            self.x, self.y, self.r, self.c)


def rect(x, y, w, h, color=cfengine_blue):
    """Returns a list of circles forming a rectangle of size w,h"""
    circles = []
    for r in range(y, y + h):
        for c in range(x, x + w):
            circles.append(Circle(c, r, radius, color))
    return circles


# Actual logo:
content = []
content += rect(3, 0, 3, 2, cfengine_orange)  # Head
content += rect(3, 3, 3, 3)  # Torso
content += rect(1, 3, 1, 4)  # Left arm
content += rect(7, 3, 1, 4)  # Right arm
content += rect(3, 7, 1, 4)  # Left leg
content += rect(5, 7, 1, 4)  # Right leg
content += rect(4, 7, 1, 1)  # Groin

# Offsets needed to center this logo in canvas:
offset_x = radius + diameter * 1
offset_y = radius

# Apply offsets to all circles:
for circle in content:
    circle.x += offset_x
    circle.y += offset_y

# The SVG container:
container = """
<svg width="{}" height="{}" version="1.1" xmlns="http://www.w3.org/2000/svg">
{}
</svg>
"""

# Render SVG, print to stdout:
content = "\n".join([str(x) for x in content])
print(container.format(width, height, content))
