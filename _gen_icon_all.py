"""
_gen_icon_all.py — Generalized icon generator for all 15 Flutter apps.
Uses the same 4× supersampling technique as JobOfferUS/_gen_icon.py.

Usage:
  python _gen_icon_all.py                  # generates icons for all apps
  python _gen_icon_all.py --app AutoLoan   # generates icon for one app only
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os
import argparse
import subprocess

# ── App config ────────────────────────────────────────────────────────────────
# symbol : 2-char code shown on the two circles and the amber bar
# type   : 'dual' — draw two circles side by side (one letter each)
# bg_top : gradient top colour (R, G, B)
# bg_bot : gradient bottom colour (R, G, B)
# cir_a  : left circle fill colour
# cir_b  : right circle fill colour
# amber  : amber bar colour

APPS = {
    'JobOfferUS':       {'symbol': 'AB', 'type': 'dual', 'bg_top': (18, 15, 50),   'bg_bot': (36, 20, 80),   'cir_a': (165, 158, 255), 'cir_b': (210, 165, 255), 'amber': (245, 158, 11)},
    'MortgageUS':       {'symbol': 'M$', 'type': 'dual', 'bg_top': (15, 26, 59),   'bg_bot': (24, 42, 90),   'cir_a': (140, 170, 255), 'cir_b': (190, 165, 120), 'amber': (212, 160, 23)},
    'MortgageCA':       {'symbol': 'M$', 'type': 'dual', 'bg_top': (10, 30, 80),   'bg_bot': (0,  40, 120),  'cir_a': (100, 170, 255), 'cir_b': (255, 130, 100), 'amber': (245, 158, 11)},
    'MortgageUK':       {'symbol': 'M£', 'type': 'dual', 'bg_top': (0,  20, 80),   'bg_bot': (0,  30, 100),  'cir_a': (140, 165, 255), 'cir_b': (210, 180, 80),  'amber': (212, 160, 23)},
    'AutoLoan':         {'symbol': 'AL', 'type': 'dual', 'bg_top': (10, 40, 15),   'bg_bot': (20, 60, 25),   'cir_a': (140, 210, 150), 'cir_b': (250, 195, 100), 'amber': (249, 168, 37)},
    'CreditCardAPR':    {'symbol': 'CC', 'type': 'dual', 'bg_top': (10, 30, 80),   'bg_bot': (15, 50, 120),  'cir_a': (130, 175, 255), 'cir_b': (200, 215, 255), 'amber': (245, 158, 11)},
    'HELOCApp':         {'symbol': 'HE', 'type': 'dual', 'bg_top': (0,  50, 48),   'bg_bot': (0,  80, 75),   'cir_a': (100, 210, 200), 'cir_b': (180, 230, 215), 'amber': (245, 158, 11)},
    'LoanPayoffUS':     {'symbol': 'LP', 'type': 'dual', 'bg_top': (40, 20, 80),   'bg_bot': (60, 30, 120),  'cir_a': (190, 160, 255), 'cir_b': (150, 235, 180), 'amber': (245, 158, 11)},
    'StudentLoan':      {'symbol': 'SL', 'type': 'dual', 'bg_top': (50, 10, 100),  'bg_bot': (70, 15, 140),  'cir_a': (200, 150, 255), 'cir_b': (220, 185, 255), 'amber': (245, 158, 11)},
    'RentBuyUS':        {'symbol': 'RB', 'type': 'dual', 'bg_top': (0,  55, 48),   'bg_bot': (0,  80, 65),   'cir_a': (100, 210, 195), 'cir_b': (140, 230, 160), 'amber': (0,  200, 83)},
    'RentalExpenses':   {'symbol': 'RE', 'type': 'dual', 'bg_top': (10, 60, 25),   'bg_bot': (15, 90, 40),   'cir_a': (130, 220, 160), 'cir_b': (180, 235, 195), 'amber': (245, 158, 11)},
    'PropertyROISuite': {'symbol': 'PR', 'type': 'dual', 'bg_top': (10, 35, 85),   'bg_bot': (15, 55, 130),  'cir_a': (130, 175, 255), 'cir_b': (250, 185, 100), 'amber': (245, 158, 11)},
    'SalaryApp':        {'symbol': 'S$', 'type': 'dual', 'bg_top': (80, 30, 10),   'bg_bot': (120, 45, 15),  'cir_a': (255, 175, 120), 'cir_b': (255, 145, 145), 'amber': (249, 168, 37)},
    'ParkSmart':        {'symbol': 'PS', 'type': 'dual', 'bg_top': (15, 20, 90),   'bg_bot': (20, 35, 120),  'cir_a': (155, 165, 255), 'cir_b': (140, 230, 155), 'amber': (0,  200, 83)},
    'rideprofit':       {'symbol': 'RP', 'type': 'dual', 'bg_top': (15, 50, 15),   'bg_bot': (25, 75, 25),   'cir_a': (140, 210, 145), 'cir_b': (250, 195, 100), 'amber': (249, 168, 37)},
}

# ── Constants ─────────────────────────────────────────────────────────────────
SIZE   = 1024
SUPER  = SIZE * 4          # 4096 — render at 4× then downscale
LETTER = (16, 12, 60)      # dark letter colour — high contrast on light circles
AMBER_DARK = (80, 40, 0)   # dark text on amber bar

# ── Font loading (verbatim from JobOfferUS/_gen_icon.py) ──────────────────────
def _load(size):
    for p in [
        "C:/Windows/Fonts/ariblk.ttf",
        "C:/Windows/Fonts/arialbd.ttf",
        "arial.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ]:
        try:
            return ImageFont.truetype(p, size)
        except Exception:
            pass
    return ImageFont.load_default()


def _draw_c(d, text, cx, cy, font, color):
    """Draw text centred at (cx, cy)."""
    bb = d.textbbox((0, 0), text, font=font)
    tw, th = bb[2] - bb[0], bb[3] - bb[1]
    d.text((cx - tw // 2 - bb[0], cy - th // 2 - bb[1]), text, font=font, fill=color)


def _resolve_assets_path(app_dir):
    """Return the correct assets output path for the app.
    Prefers assets/images/, falls back to assets/icons/.
    """
    images_path = os.path.join(app_dir, 'assets', 'images')
    icons_path  = os.path.join(app_dir, 'assets', 'icons')
    if os.path.isdir(images_path):
        return images_path, os.path.join(images_path, 'icon.png')
    if os.path.isdir(icons_path):
        return icons_path, os.path.join(icons_path, 'icon.png')
    # Create assets/images/ if neither exists
    os.makedirs(images_path, exist_ok=True)
    return images_path, os.path.join(images_path, 'icon.png')


def generate_icon(app_name, cfg, base_dir='D:/mob'):
    """Generate a 1024×1024 icon for the given app using 4× supersampling."""
    app_dir = os.path.join(base_dir, app_name)
    if not os.path.isdir(app_dir):
        print(f'  [SKIP] {app_name}: directory not found at {app_dir}')
        return

    assets_dir, out_path = _resolve_assets_path(app_dir)

    BG_TOP = cfg['bg_top']
    BG_BOT = cfg['bg_bot']
    CIR_A  = cfg['cir_a']
    CIR_B  = cfg['cir_b']
    AMBER  = cfg['amber']
    symbol = cfg['symbol']     # exactly 2 chars — split for dual layout
    letter_a = symbol[0]
    letter_b = symbol[1]

    W = H = SUPER

    # ── 4× supersampled canvas ────────────────────────────────────────────────
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))

    # gradient background
    bg = Image.new("RGB", (W, H))
    bd = ImageDraw.Draw(bg)
    for y in range(H):
        t = y / (H - 1)
        r = int(BG_TOP[0] + (BG_BOT[0] - BG_TOP[0]) * t)
        g = int(BG_TOP[1] + (BG_BOT[1] - BG_TOP[1]) * t)
        b = int(BG_TOP[2] + (BG_BOT[2] - BG_TOP[2]) * t)
        bd.line([(0, y), (W - 1, y)], fill=(r, g, b))
    img.paste(bg)
    img.putalpha(255)

    # rounded-rect mask (iOS-style, radius = 224 @ 1× → 896 @ 4×)
    mask = Image.new("L", (W, H), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, W - 1, H - 1], radius=896, fill=255)
    img.putalpha(mask)
    draw = ImageDraw.Draw(img)

    # ── subtle centre glow ────────────────────────────────────────────────────
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(glow).ellipse([W // 4, H // 4, 3 * W // 4, 3 * H // 4],
                                  fill=(80, 60, 180, 30))
    glow = glow.filter(ImageFilter.GaussianBlur(radius=300))
    img = Image.alpha_composite(img, glow)
    draw = ImageDraw.Draw(img)

    # ── circles (at 4× scale) ─────────────────────────────────────────────────
    # At 1×: circles at ~230px radius, offset ±230px from centre
    # At 4×: radius = 900, offset = 880
    CY = H // 2 - 120   # shift slightly up
    R  = 900
    AX = W // 2 - 880   # left circle centre-x
    BX = W // 2 + 880   # right circle centre-x

    # white glow ring behind each circle for separation from background
    for cx_c, cy_c in [(AX, CY), (BX, CY)]:
        draw.ellipse([cx_c - R - 24, cy_c - R - 24, cx_c + R + 24, cy_c + R + 24],
                     fill=(255, 255, 255, 25))

    draw.ellipse([AX - R, CY - R, AX + R, CY + R], fill=CIR_A)
    draw.ellipse([BX - R, CY - R, BX + R, CY + R], fill=CIR_B)

    # ── letters ───────────────────────────────────────────────────────────────
    fnt    = _load(880)   # 4× of 220
    fnt_vs = _load(112)   # 4× of 28

    _draw_c(draw, letter_a, AX, CY, fnt, LETTER)
    _draw_c(draw, letter_b, BX, CY, fnt, LETTER)

    # ── amber bar (shows the 2-char app code) ─────────────────────────────────
    BAR_W, BAR_H = 1840, 160
    BAR_Y = CY + R + 220
    CX = W // 2
    draw.rounded_rectangle(
        [CX - BAR_W // 2, BAR_Y, CX + BAR_W // 2, BAR_Y + BAR_H],
        radius=80, fill=AMBER)
    _draw_c(draw, symbol, CX, BAR_Y + BAR_H // 2, fnt_vs, AMBER_DARK)

    # ── border ring — crisp white glow ────────────────────────────────────────
    for off, a in [(0, 55), (32, 30), (64, 12)]:
        draw.rounded_rectangle(
            [off, off, W - off, H - off],
            radius=896 - off,
            outline=(220, 210, 255, a), width=24)

    # Crisp bright ring at inset 40px (≈ 10px at 1×)
    draw.rounded_rectangle(
        [40, 40, W - 40, H - 40],
        radius=856,
        outline=(255, 255, 255, 100), width=40)

    # ── 4× → 1× downsample (LANCZOS antialiasing) ────────────────────────────
    final = img.resize((SIZE, SIZE), Image.LANCZOS)
    final.save(out_path, "PNG")
    print(f'  [OK] {app_name}: icon saved -> {out_path}  ({SIZE}x{SIZE}) [4x supersampled]')

    # ── Run flutter_launcher_icons ────────────────────────────────────────────
    print(f'  [RUN] {app_name}: dart run flutter_launcher_icons ...')
    result = subprocess.run(
        'dart run flutter_launcher_icons',
        cwd=app_dir,
        capture_output=True,
        text=True,
        shell=True,
    )
    if result.returncode == 0:
        print(f'  [OK] {app_name}: flutter_launcher_icons completed.')
    else:
        print(f'  [WARN] {app_name}: flutter_launcher_icons exited {result.returncode}')
        if result.stdout:
            print(result.stdout[-800:])
        if result.stderr:
            print(result.stderr[-400:])


def main():
    parser = argparse.ArgumentParser(
        description='Generate app icons for Flutter apps using 4× supersampling.')
    parser.add_argument('--app', metavar='APPNAME',
                        help='Process only this app (default: all apps)')
    args = parser.parse_args()

    if args.app:
        if args.app not in APPS:
            print(f'Error: "{args.app}" not found in APPS config.')
            print(f'Available: {", ".join(APPS.keys())}')
            return
        targets = {args.app: APPS[args.app]}
    else:
        targets = APPS

    base_dir = os.path.dirname(os.path.abspath(__file__))

    print(f'Generating icons for {len(targets)} app(s)...\n')
    for app_name, cfg in targets.items():
        generate_icon(app_name, cfg, base_dir=base_dir)

    print('\nDone.')


if __name__ == '__main__':
    main()
