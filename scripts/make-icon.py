import json
import math
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "Resources/Assets.xcassets"
DOCS = ROOT / "docs"
NAME = "SOFTFOLD"
SIGNATURE = "REFFWU"
FONT_PATH = "/System/Library/Fonts/Optima.ttc"
FONT_SIZE = 46
TRACKING = 16
SIZE = 2048
SCALE = 2
INNER = (176, 176, 1872, 1872)
INNER_RADIUS = 392
FRAME = 132
OUTER = (INNER[0] - FRAME, INNER[1] - FRAME, INNER[2] + FRAME, INNER[3] + FRAME)
OUTER_RADIUS = INNER_RADIUS + FRAME
FRAMES = {
    "dark": ((26, 26, 28), (128, 128, 134, 255), 60),
}
HINGE_Y = 1058
LID_TOP = 350
BACK = (470, 1578)
FRONT_Y = 1580
FRONT = (242, 1806)
THICKNESS = 20
BEZEL = 22
LID = [(300, LID_TOP), (1748, LID_TOP), (BACK[1], HINGE_Y), (BACK[0], HINGE_Y)]
SCREEN = (BACK[0] + 40, LID_TOP + 34, BACK[1] - 40, HINGE_Y - 22)
DECK = [
    (BACK[0], HINGE_Y),
    (BACK[1], HINGE_Y),
    (FRONT[1], FRONT_Y),
    (FRONT[0], FRONT_Y),
]
KEYBOARD_Y = (HINGE_Y + 54, 1300)
TRACKPAD = [(800, 1350), (1248, 1350), (1284, 1520), (764, 1520)]
POINTS = [16, 32, 128, 256, 512]
BACKGROUND = ((128, 124, 128), (56, 54, 60))


def blank():
    return Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))


def polygon_mask(points):
    mask = Image.new("L", (SIZE * SCALE, SIZE * SCALE), 0)
    ImageDraw.Draw(mask).polygon([(x * SCALE, y * SCALE) for x, y in points], fill=255)
    return mask.resize((SIZE, SIZE), Image.LANCZOS)


def rounded_mask(box, radius):
    mask = Image.new("L", (SIZE * SCALE, SIZE * SCALE), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [value * SCALE for value in box], radius=radius * SCALE, fill=255
    )
    return mask.resize((SIZE, SIZE), Image.LANCZOS)


def rounded(points, radii, steps=12):
    result = []
    for index, corner in enumerate(points):
        corner = np.array(corner, float)
        before = np.array(points[index - 1], float) - corner
        after = np.array(points[(index + 1) % len(points)], float) - corner
        reach = min(radii[index], np.linalg.norm(before) / 2, np.linalg.norm(after) / 2)
        start = corner + before / np.linalg.norm(before) * reach
        end = corner + after / np.linalg.norm(after) * reach
        for t in np.linspace(0, 1, steps):
            point = (1 - t) ** 2 * start + 2 * (1 - t) * t * corner + t**2 * end
            result.append(tuple(point))
    return result


def fill(source, mask):
    if isinstance(source, tuple):
        source = Image.new("RGBA", (SIZE, SIZE), source)
    layer = blank()
    layer.paste(source.convert("RGBA"), (0, 0), mask)
    return layer


def vertical_gradient(top, bottom, start, end):
    ramp = np.linspace(0, 1, end - start)[:, None]
    rows = np.array(top) * (1 - ramp) + np.array(bottom) * ramp
    strip = np.repeat(rows[:, None, :], SIZE, axis=1).astype(np.uint8)
    image = Image.new("RGB", (SIZE, SIZE), tuple(top))
    image.paste(Image.fromarray(strip), (0, start))
    return image


def across(points, t):
    left = points[0][0] + (points[3][0] - points[0][0]) * t
    right = points[1][0] + (points[2][0] - points[1][0]) * t
    return left, right


def wallpaper(width, height):
    y, x = np.mgrid[0:height, 0:width] / np.array([height, width]).reshape(2, 1, 1)
    t = np.clip(y * 0.85 + x * 0.2, 0, 1)[..., None]
    pixels = np.array([0x7A, 0xA8, 0xFF]) * (1 - t) + np.array([0x24, 0x36, 0x9C]) * t
    waves = [
        (0.07, 0.5, 0.0, (170, 205, 255), 0.55),
        (0.08, 0.68, 1.7, (90, 120, 235), 0.6),
        (0.05, 0.85, 3.1, (40, 60, 170), 0.7),
    ]
    for amplitude, offset, phase, color, alpha in waves:
        edge = offset + amplitude * np.sin(x * 2 * np.pi * 1.1 + phase)
        mask = np.clip((y - edge) * 60, 0, 1)[..., None] * alpha
        pixels = pixels * (1 - mask) + np.array(color) * mask
    image = Image.fromarray(pixels.astype(np.uint8)).convert("RGBA")
    draw = ImageDraw.Draw(image, "RGBA")
    draw.rectangle((0, 0, width, int(height * 0.035)), fill=(255, 255, 255, 95))
    left, top = int(width * 0.26), int(height * 0.22)
    right, bottom = int(width * 0.74), int(height * 0.68)
    bar = top + int(height * 0.075)
    radius = int(width * 0.03)
    draw.rounded_rectangle(
        (left, top, right, bottom), radius=radius, fill=(236, 238, 246, 220)
    )
    draw.rounded_rectangle(
        (left, top, right, bar), radius=radius, fill=(222, 224, 232, 240)
    )
    draw.rectangle(
        (left, top + int(height * 0.04), right, bar), fill=(222, 224, 232, 240)
    )
    dot = int(height * 0.018)
    for index, color in enumerate([(255, 95, 87), (254, 188, 46), (40, 200, 64)]):
        cx = left + int(width * 0.035) + index * int(dot * 2.8)
        cy = top + int(height * 0.0375)
        draw.ellipse((cx - dot, cy - dot, cx + dot, cy + dot), fill=(*color, 255))
    return image


def progressive_blur(image, radius, start, end):
    radii = [0, 3, 6, 10, 16, 24, 34, 46, 60, 76, 94, 114, 136]
    radii = [value for value in radii if value < radius] + [radius]
    levels = [
        np.asarray(
            image if value == 0 else image.filter(ImageFilter.GaussianBlur(value))
        ).astype(float)
        for value in radii
    ]
    result = levels[0].copy()
    for row in range(start, end):
        progress = (row - start) / (end - start)
        target = radius * (1 - progress) ** 1.25
        upper = next(index for index, value in enumerate(radii) if value >= target)
        lower = max(upper - 1, 0)
        span = radii[upper] - radii[lower]
        blend = 0 if span == 0 else (target - radii[lower]) / span
        result[row] = levels[lower][row] * (1 - blend) + levels[upper][row] * blend
    return Image.fromarray(result.astype(np.uint8))


def inset(points, distance):
    lines = []
    for index, start in enumerate(points):
        end = points[(index + 1) % len(points)]
        dx, dy = end[0] - start[0], end[1] - start[1]
        length = math.hypot(dx, dy)
        nx, ny = -dy / length, dx / length
        lines.append(
            (
                (start[0] + nx * distance, start[1] + ny * distance),
                (end[0] + nx * distance, end[1] + ny * distance),
            )
        )
    corners = []
    for index, (first, second) in enumerate(zip(lines[-1:] + lines[:-1], lines)):
        (x1, y1), (x2, y2) = first
        (x3, y3), (x4, y4) = second
        denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        cross = x1 * y2 - y1 * x2, x3 * y4 - y3 * x4
        corners.append(
            (
                (cross[0] * (x3 - x4) - (x1 - x2) * cross[1]) / denominator,
                (cross[0] * (y3 - y4) - (y1 - y2) * cross[1]) / denominator,
            )
        )
    return corners


def laptop():
    canvas = vertical_gradient(*BACKGROUND, INNER[1], INNER[3])
    canvas = canvas.convert("RGBA")
    glow = fill((120, 160, 255, 110), polygon_mask(LID))
    canvas = Image.alpha_composite(canvas, glow.filter(ImageFilter.GaussianBlur(170)))
    shadow = blank()
    ImageDraw.Draw(shadow).ellipse(
        (FRONT[0] - 40, FRONT_Y - 70, FRONT[1] + 40, FRONT_Y + 90), fill=(0, 0, 0, 160)
    )
    canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(50)))

    base = [
        DECK[0],
        DECK[1],
        (FRONT[1], FRONT_Y + THICKNESS),
        (FRONT[0], FRONT_Y + THICKNESS),
    ]
    base_mask = polygon_mask(rounded(base, [8, 8, 34, 34]))
    canvas = Image.alpha_composite(canvas, fill((112, 118, 132, 255), base_mask))
    deck_mask = polygon_mask(rounded(DECK, [8, 8, 30, 30]))
    metal = vertical_gradient((208, 212, 221), (170, 176, 188), HINGE_Y, FRONT_Y)
    canvas = Image.alpha_composite(canvas, fill(metal, deck_mask))

    keyboard_t = [
        (KEYBOARD_Y[0] - HINGE_Y) / (FRONT_Y - HINGE_Y),
        (KEYBOARD_Y[1] - HINGE_Y) / (FRONT_Y - HINGE_Y),
    ]
    top_left, top_right = across(DECK, keyboard_t[0])
    bottom_left, bottom_right = across(DECK, keyboard_t[1])
    keyboard = [
        (top_left + 90, KEYBOARD_Y[0]),
        (top_right - 90, KEYBOARD_Y[0]),
        (bottom_right - 110, KEYBOARD_Y[1]),
        (bottom_left + 110, KEYBOARD_Y[1]),
    ]
    canvas = Image.alpha_composite(
        canvas, fill((56, 58, 66, 255), polygon_mask(rounded(keyboard, [16] * 4)))
    )
    rows = blank()
    draw = ImageDraw.Draw(rows)
    for index in range(1, 5):
        t = index / 5
        y = keyboard[0][1] + (keyboard[3][1] - keyboard[0][1]) * t
        left, right = across(keyboard, t)
        draw.line([(left, y), (right, y)], fill=(86, 90, 100, 255), width=5)
    canvas = Image.alpha_composite(canvas, fill(rows, polygon_mask(keyboard)))
    pad_mask = polygon_mask(rounded(TRACKPAD, [22] * 4))
    canvas = Image.alpha_composite(canvas, fill((190, 195, 206, 255), pad_mask))

    lid = Image.new("RGBA", (SIZE, SIZE), (20, 22, 30, 255))
    lid.paste(wallpaper(SCREEN[2] - SCREEN[0], SCREEN[3] - SCREEN[1]), SCREEN[:2])
    lid = progressive_blur(lid.convert("RGB"), 120, LID_TOP, HINGE_Y)
    lid_mask = polygon_mask(rounded(LID, [22, 22, 6, 6]))
    canvas = Image.alpha_composite(canvas, fill(lid, lid_mask))
    glass = polygon_mask(rounded(inset(LID, BEZEL), [12, 12, 4, 4]))
    ring = Image.fromarray(
        (np.asarray(lid_mask, int) * (255 - np.asarray(glass, int)) // 255).astype(
            np.uint8
        )
    )
    return Image.alpha_composite(canvas, fill((6, 6, 8, 255), ring))


def ring_point(distance, box, radius):
    x0, y0, x1, y1 = box
    width, height = x1 - x0 - 2 * radius, y1 - y0 - 2 * radius
    arc = math.pi * radius / 2
    segments = [
        ("line", (x0 + radius + width / 2, y0), (x1 - radius, y0), width / 2),
        ("arc", (x1 - radius, y0 + radius), -90, 0, arc),
        ("line", (x1, y0 + radius), (x1, y1 - radius), height),
        ("arc", (x1 - radius, y1 - radius), 0, 90, arc),
        ("line", (x1 - radius, y1), (x0 + radius, y1), width),
        ("arc", (x0 + radius, y1 - radius), 90, 180, arc),
        ("line", (x0, y1 - radius), (x0, y0 + radius), height),
        ("arc", (x0 + radius, y0 + radius), 180, 270, arc),
        ("line", (x0 + radius, y0), (x0 + radius + width / 2, y0), width / 2),
    ]
    distance %= sum(segment[-1] for segment in segments)
    for segment in segments:
        if distance <= segment[-1]:
            share = distance / segment[-1]
            if segment[0] == "line":
                (ax, ay), (bx, by) = segment[1], segment[2]
                angle = math.degrees(math.atan2(by - ay, bx - ax))
                return ax + (bx - ax) * share, ay + (by - ay) * share, angle
            (cx, cy), start, end = segment[1], segment[2], segment[3]
            angle = math.radians(start + (end - start) * share)
            x, y = cx + radius * math.cos(angle), cy + radius * math.sin(angle)
            return x, y, math.degrees(angle) + 90
        distance -= segment[-1]
    raise ValueError("distance outside the frame")


def engrave(canvas, text, position, color, upright):
    font = ImageFont.truetype(FONT_PATH, FONT_SIZE * SCALE)
    inset = FRAME / 2
    box = (OUTER[0] + inset, OUTER[1] + inset, OUTER[2] - inset, OUTER[3] - inset)
    radius = (OUTER_RADIUS + INNER_RADIUS) / 2
    perimeter = (
        2 * (box[2] - box[0] - 2 * radius)
        + 2 * (box[3] - box[1] - 2 * radius)
        + 2 * math.pi * radius
    )
    widths = [font.getlength(letter) / SCALE for letter in text]
    total = sum(widths) + TRACKING * (len(text) - 1)
    direction = -1 if upright else 1
    cursor = position * perimeter - direction * total / 2
    layer = Image.new("RGBA", (SIZE * SCALE, SIZE * SCALE), (0, 0, 0, 0))
    for letter, width in zip(text, widths):
        x, y, angle = ring_point(cursor + direction * width / 2, box, radius)
        if upright:
            angle += 180
        side = FONT_SIZE * 2 * SCALE
        glyph = Image.new("RGBA", (side, side), (0, 0, 0, 0))
        ImageDraw.Draw(glyph).text(
            (side / 2, side / 2), letter, font=font, fill=color, anchor="mm"
        )
        glyph = glyph.rotate(-angle, resample=Image.BICUBIC)
        layer.alpha_composite(
            glyph, (int(x * SCALE - side / 2), int(y * SCALE - side / 2))
        )
        cursor += direction * (width + TRACKING)
    return Image.alpha_composite(canvas, layer.resize((SIZE, SIZE), Image.LANCZOS))


def framed(face, style):
    frame_color, text_color, rim_alpha = FRAMES[style]
    outer = rounded_mask(OUTER, OUTER_RADIUS)
    canvas = fill((*frame_color, 255), outer)
    canvas = Image.alpha_composite(
        canvas, fill(face, rounded_mask(INNER, INNER_RADIUS))
    )
    rim = blank()
    ImageDraw.Draw(rim).rounded_rectangle(
        INNER, radius=INNER_RADIUS, outline=(255, 255, 255, rim_alpha), width=4
    )
    canvas = Image.alpha_composite(canvas, rim)
    canvas = engrave(canvas, NAME, 0.875, text_color, False)
    canvas = engrave(canvas, SIGNATURE, 0.375, text_color, True)
    shadow = fill((0, 0, 0, 85), outer).filter(ImageFilter.GaussianBlur(42))
    shadow = shadow.transform((SIZE, SIZE), Image.AFFINE, (1, 0, 0, 0, 1, -20))
    return Image.alpha_composite(shadow, canvas)


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2) + "\n")


def main():
    face = laptop()
    icons = {style: framed(face, style) for style in FRAMES}
    info = {"author": "xcode", "version": 1}
    appicon = ASSETS / "AppIcon.appiconset"
    appicon.mkdir(parents=True, exist_ok=True)
    images = []
    for point in POINTS:
        for scale in (1, 2):
            name = f"icon_{point}x{point}{'@2x' if scale == 2 else ''}.png"
            pixels = point * scale
            icons["dark"].resize((pixels, pixels), Image.LANCZOS).save(appicon / name)
            images.append(
                {
                    "filename": name,
                    "idiom": "mac",
                    "scale": f"{scale}x",
                    "size": f"{point}x{point}",
                }
            )
    write_json(appicon / "Contents.json", {"images": images, "info": info})
    DOCS.mkdir(exist_ok=True)
    icons["dark"].resize((512, 512), Image.LANCZOS).save(DOCS / "icon.png")


if __name__ == "__main__":
    main()
