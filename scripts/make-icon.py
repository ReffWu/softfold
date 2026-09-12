import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
APPICON = ROOT / "Resources/Assets.xcassets/AppIcon.appiconset"
DOCS = ROOT / "docs"
SIZE = 2048
INNER = (176, 176, 1872, 1872)
INNER_RADIUS = 392
FRAME = 132
OUTER = (INNER[0] - FRAME, INNER[1] - FRAME, INNER[2] + FRAME, INNER[3] + FRAME)
OUTER_RADIUS = INNER_RADIUS + FRAME
DESK_W, DESK_H = 1600, 1200
BLUR_RADIUS = 150
BLUR_FADE = 0.95
POINTS = [16, 32, 128, 256, 512]


def rounded_mask(box, radius):
    scale = 2
    mask = Image.new("L", (SIZE * scale, SIZE * scale), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [value * scale for value in box], radius=radius * scale, fill=255
    )
    return mask.resize((SIZE, SIZE), Image.LANCZOS)


def framed(face, frame_rgb, rim_alpha):
    outer = rounded_mask(OUTER, OUTER_RADIUS)
    inner = rounded_mask(INNER, INNER_RADIUS)
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    canvas.paste((*frame_rgb, 255), (0, 0), outer)
    content = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    content.paste(face, (0, 0), inner)
    canvas = Image.alpha_composite(canvas, content)
    rim = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ImageDraw.Draw(rim).rounded_rectangle(
        INNER, radius=INNER_RADIUS, outline=(255, 255, 255, rim_alpha), width=4
    )
    canvas = Image.alpha_composite(canvas, rim)
    shadow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    shadow.paste((0, 0, 0, 85), (0, 0), outer)
    shadow = shadow.filter(ImageFilter.GaussianBlur(42)).transform(
        (SIZE, SIZE), Image.AFFINE, (1, 0, 0, 0, 1, -20)
    )
    return Image.alpha_composite(shadow, canvas)


def desktop():
    y, x = np.mgrid[0:DESK_H, 0:DESK_W] / np.array([DESK_H, DESK_W]).reshape(2, 1, 1)
    t = np.clip(y * 0.8 + x * 0.25, 0, 1)[..., None]
    pixels = np.array([0x7A, 0xA8, 0xFF]) * (1 - t) + np.array([0x24, 0x36, 0x9C]) * t
    waves = [
        (0.07, 0.46, 0.0, (170, 205, 255), 0.55),
        (0.09, 0.64, 1.7, (90, 120, 235), 0.6),
        (0.06, 0.82, 3.1, (40, 60, 170), 0.7),
    ]
    for amplitude, offset, phase, color, alpha in waves:
        edge = offset + amplitude * np.sin(x * 2 * np.pi * 1.1 + phase)
        mask = np.clip((y - edge) * 40, 0, 1)[..., None] * alpha
        pixels = pixels * (1 - mask) + np.array(color) * mask
    image = Image.fromarray(pixels.astype(np.uint8)).convert("RGBA")
    draw = ImageDraw.Draw(image, "RGBA")
    draw.rectangle((0, 0, DESK_W, 34), fill=(255, 255, 255, 90))
    draw.rounded_rectangle((360, 230, 1240, 800), radius=36, fill=(250, 250, 252, 235))
    draw.rounded_rectangle((360, 230, 1240, 300), radius=36, fill=(232, 232, 238, 255))
    draw.rectangle((360, 265, 1240, 300), fill=(232, 232, 238, 255))
    for index, color in enumerate([(255, 95, 87), (254, 188, 46), (40, 200, 64)]):
        left = 400 + index * 52
        draw.ellipse((left, 250, left + 32, 282), fill=(*color, 255))
    return image


def progressive_blur(image):
    radii = [0, 0.06, 0.15, 0.3, 0.55, 1.0]
    levels = [
        np.asarray(
            image
            if radius == 0
            else image.filter(ImageFilter.GaussianBlur(BLUR_RADIUS * radius))
        ).astype(float)
        for radius in radii
    ]
    rows = np.linspace(0, 1, image.height)
    strength = np.clip(1 - rows / BLUR_FADE, 0, 1) ** 1.6 * (len(radii) - 1)
    result = np.zeros_like(levels[0])
    for row in range(image.height):
        level = int(np.floor(strength[row]))
        if level >= len(radii) - 1:
            result[row] = levels[-1][row]
            continue
        blend = strength[row] - level
        result[row] = levels[level][row] * (1 - blend) + levels[level + 1][row] * blend
    return Image.fromarray(result.astype(np.uint8))


def perspective(source, target):
    rows, values = [], []
    for (tx, ty), (sx, sy) in zip(target, source):
        rows.append([tx, ty, 1, 0, 0, 0, -sx * tx, -sx * ty])
        values.append(sx)
        rows.append([0, 0, 0, tx, ty, 1, -sy * tx, -sy * ty])
        values.append(sy)
    return np.linalg.solve(np.array(rows, float), np.array(values, float))


def face():
    canvas = Image.new("RGBA", (SIZE, SIZE), (6, 6, 8, 255))
    quad = [
        (520, INNER[1]),
        (1528, INNER[1]),
        (INNER[2] + 40, INNER[3]),
        (INNER[0] - 40, INNER[3]),
    ]
    screen = desktop()
    shade = np.zeros((DESK_H, DESK_W, 4), np.uint8)
    shade[..., 3] = (
        np.clip(1 - np.linspace(0, 1, DESK_H) / 0.6, 0, 1) ** 1.2 * 70
    ).astype(np.uint8)[:, None]
    screen = Image.alpha_composite(screen, Image.fromarray(shade))
    scale = 2
    coefficients = perspective(
        [(0, 0), (DESK_W, 0), (DESK_W, DESK_H), (0, DESK_H)],
        [(x * scale, y * scale) for x, y in quad],
    )
    warped = screen.transform(
        (SIZE * scale, SIZE * scale), Image.PERSPECTIVE, coefficients, Image.BICUBIC
    ).resize((SIZE, SIZE), Image.LANCZOS)
    glow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ImageDraw.Draw(glow).polygon(quad, fill=(60, 100, 255, 110))
    canvas = Image.alpha_composite(canvas, glow.filter(ImageFilter.GaussianBlur(90)))
    canvas = Image.alpha_composite(canvas, warped)
    edges = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(edges)
    draw.line([quad[0], quad[3]], fill=(255, 255, 255, 50), width=5)
    draw.line([quad[1], quad[2]], fill=(255, 255, 255, 50), width=5)
    canvas = Image.alpha_composite(canvas, edges)
    return progressive_blur(canvas.convert("RGB")).convert("RGBA")


def main():
    content = face()
    icon = framed(content, (26, 26, 28), 60)
    APPICON.mkdir(parents=True, exist_ok=True)
    images = []
    for point in POINTS:
        for scale in (1, 2):
            name = f"icon_{point}x{point}{'@2x' if scale == 2 else ''}.png"
            icon.resize((point * scale, point * scale), Image.LANCZOS).save(
                APPICON / name
            )
            images.append(
                {
                    "filename": name,
                    "idiom": "mac",
                    "scale": f"{scale}x",
                    "size": f"{point}x{point}",
                }
            )
    contents = {"images": images, "info": {"author": "xcode", "version": 1}}
    (APPICON / "Contents.json").write_text(json.dumps(contents, indent=2) + "\n")
    DOCS.mkdir(exist_ok=True)
    icon.resize((512, 512), Image.LANCZOS).save(DOCS / "icon.png")


if __name__ == "__main__":
    main()
