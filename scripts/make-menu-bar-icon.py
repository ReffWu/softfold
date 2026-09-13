#!/usr/bin/env python3

import json
import os
import subprocess
import tempfile


def f(v):
    return f"{v:.3f}".rstrip("0").rstrip(".")


def svg(body):
    return (
        '<svg width="18" height="18" viewBox="0 0 18 18" fill="none" '
        'xmlns="http://www.w3.org/2000/svg">' + body + "</svg>"
    )


RASTERIZE = r"""
import AppKit
let args = CommandLine.arguments
let image = NSImage(contentsOfFile: args[1])!
let pixels = Int(args[3])!
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
rep.size = NSSize(width: 18, height: 18)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
image.draw(in: NSRect(x: 0, y: 0, width: 18, height: 18))
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: args[2]))
"""


def write_imageset(folder, name, one_x_svg, two_x_svg):
    path = os.path.join(folder, name + ".imageset")
    os.makedirs(path, exist_ok=True)
    for existing in os.listdir(path):
        os.remove(os.path.join(path, existing))
    with tempfile.TemporaryDirectory() as tmp:
        script = os.path.join(tmp, "rasterize.swift")
        open(script, "w").write(RASTERIZE)
        for scale, source in ((1, one_x_svg), (2, two_x_svg)):
            src = os.path.join(tmp, f"{scale}.svg")
            open(src, "w").write(source)
            subprocess.run(
                [
                    "swift",
                    script,
                    src,
                    os.path.join(path, f"{name}@{scale}x.png"),
                    str(18 * scale),
                ],
                check=True,
            )
    contents = json.dumps(
        {
            "images": [
                {"filename": f"{name}@1x.png", "idiom": "universal", "scale": "1x"},
                {"filename": f"{name}@2x.png", "idiom": "universal", "scale": "2x"},
                {"idiom": "universal", "scale": "3x"},
            ],
            "info": {"author": "xcode", "version": 1},
            "properties": {"template-rendering-intent": "template"},
        },
        indent=2,
    )
    with open(os.path.join(path, "Contents.json"), "w") as file:
        file.write(contents + "\n")


def trapezoid(tl, tr, ty, bl, br, by):
    return f"M{f(tl)} {f(ty)}L{f(tr)} {f(ty)}L{f(br)} {f(by)}L{f(bl)} {f(by)}Z"


def deck(top_l, top_r, top_y, bot_l, bot_r, bot_y, r):
    return (
        f"M{f(top_l + 0.3)} {f(top_y)}L{f(top_r - 0.3)} {f(top_y)}"
        f"C{f(top_r + 0.1)} {f(top_y)} {f(top_r + 0.3)} {f(top_y + 0.15)} {f(top_r + 0.45)} {f(top_y + 0.35)}"
        f"L{f(bot_r - 0.2)} {f(bot_y - r)}"
        f"C{f(bot_r + 0.15)} {f(bot_y - r * 0.35)} {f(bot_r - 0.1)} {f(bot_y)} {f(bot_r - r)} {f(bot_y)}"
        f"L{f(bot_l + r)} {f(bot_y)}"
        f"C{f(bot_l + 0.1)} {f(bot_y)} {f(bot_l - 0.15)} {f(bot_y - r * 0.35)} {f(bot_l + 0.2)} {f(bot_y - r)}"
        f"L{f(top_l - 0.45)} {f(top_y + 0.35)}"
        f"C{f(top_l - 0.3)} {f(top_y + 0.15)} {f(top_l - 0.1)} {f(top_y)} {f(top_l + 0.3)} {f(top_y)}Z"
    )


def two_x(active):
    body = ""
    if active:
        body += (
            f'<path d="{trapezoid(3.8, 14.2, 3.55, 5.1, 12.9, 9.2)}" fill="black" fill-opacity="0.5" '
            'stroke="black" stroke-opacity="0.5" stroke-width="0.4" stroke-linejoin="round"/>'
        )
    body += f'<path d="{trapezoid(2.25, 15.75, 2.25, 4.0, 14.0, 10.25)}" stroke="black" stroke-width="1.5" stroke-linejoin="round"/>'
    body += (
        f'<path d="{deck(3.25, 14.75, 12.0, 0.75, 17.25, 15.0, 0.9)}" fill="black"/>'
    )
    return svg(body)


def one_x(active):
    body = ""
    if active:
        body += f'<path d="{trapezoid(3.5, 14.5, 3.0, 5.0, 13.0, 10.0)}" fill="black" fill-opacity="0.5"/>'
    body += f'<path d="{trapezoid(2.5, 15.5, 2.5, 4.5, 13.5, 10.5)}" stroke="black" stroke-width="1" stroke-linejoin="round"/>'
    body += '<path d="M3 12H15L17 15H1Z" fill="black"/>'
    return svg(body)


if __name__ == "__main__":
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    assets = os.path.join(root, "Resources", "Assets.xcassets")
    write_imageset(assets, "MenuBarIcon", one_x(False), two_x(False))
    write_imageset(assets, "MenuBarIconActive", one_x(True), two_x(True))
    print("wrote MenuBarIcon and MenuBarIconActive")
