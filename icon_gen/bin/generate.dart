import 'dart:io';
import 'package:image/image.dart' as img;

// ─── Drawing Helpers ─────────────────────────────────────────────────────────

void drawRoundedRect(img.Image image, int x, int y, int w, int h, int r, img.Color color) {
  img.fillRect(image, x1: x + r, y1: y, x2: x + w - r, y2: y + h, color: color);
  img.fillRect(image, x1: x, y1: y + r, x2: x + w, y2: y + h - r, color: color);
  img.fillCircle(image, x: x + r, y: y + r, radius: r, color: color);
  img.fillCircle(image, x: x + w - r, y: y + r, radius: r, color: color);
  img.fillCircle(image, x: x + r, y: y + h - r, radius: r, color: color);
  img.fillCircle(image, x: x + w - r, y: y + h - r, radius: r, color: color);
}

// Upward-pointing triangle: tip at (cx, tipY), wide base at baseY
void drawTriangle(img.Image image, int cx, int tipY, int baseY, int baseHalfW, img.Color color) {
  final h = baseY - tipY;
  if (h <= 0) return;
  for (int dy = 0; dy <= h; dy++) {
    final rowW = (baseHalfW * dy / h).round();
    img.drawLine(image, x1: cx - rowW, y1: tipY + dy, x2: cx + rowW, y2: tipY + dy,
        color: color, thickness: 1);
  }
}

void drawThickCircle(img.Image image, int cx, int cy, int radius, int thickness, img.Color color) {
  for (int r = (radius - thickness).clamp(0, 9999); r <= radius; r++) {
    if (r > 0) img.drawCircle(image, x: cx, y: cy, radius: r, color: color);
  }
}

void drawCheck(img.Image image, int cx, int cy, int size, img.Color color) {
  final sw = (size * 0.18).toInt().clamp(2, 16);
  img.drawLine(image,
      x1: (cx - size * 0.38).toInt(), y1: cy,
      x2: (cx - size * 0.05).toInt(), y2: (cy + size * 0.36).toInt(),
      color: color, thickness: sw);
  img.drawLine(image,
      x1: (cx - size * 0.05).toInt(), y1: (cy + size * 0.36).toInt(),
      x2: (cx + size * 0.48).toInt(), y2: (cy - size * 0.38).toInt(),
      color: color, thickness: sw);
}

// Dollar sign (vertical bar + 3 horizontal bars)
void drawDollarSign(img.Image image, int cx, int cy, int sz, img.Color color) {
  final vw = (sz * 0.14).toInt().clamp(2, 14);
  final bw = sz * 62 ~/ 100;
  final bh = vw;
  img.fillRect(image, x1: cx - vw ~/ 2, y1: cy - sz * 48 ~/ 100,
      x2: cx + vw ~/ 2, y2: cy + sz * 48 ~/ 100, color: color);
  for (final dy in [-(sz * 28 ~/ 100), 0, sz * 28 ~/ 100]) {
    img.fillRect(image, x1: cx - bw ~/ 2, y1: cy + dy - bh ~/ 2,
        x2: cx + bw ~/ 2, y2: cy + dy + bh ~/ 2, color: color);
  }
}

// House: triangle roof + body rect + door cutout
void drawHouse(img.Image image, int cx, int cy, int sz, img.Color bodyColor, img.Color doorColor) {
  final hw = sz * 68 ~/ 100;
  final bh = sz * 33 ~/ 100;
  final bt = cy - bh ~/ 2 + sz * 6 ~/ 100;
  drawTriangle(image, cx, cy - sz * 42 ~/ 100, bt, hw ~/ 2, bodyColor);
  img.fillRect(image, x1: cx - hw ~/ 2, y1: bt, x2: cx + hw ~/ 2, y2: bt + bh, color: bodyColor);
  final dw = hw * 24 ~/ 100;
  final dh = bh * 52 ~/ 100;
  img.fillRect(image, x1: cx - dw ~/ 2, y1: bt + bh - dh,
      x2: cx + dw ~/ 2, y2: bt + bh, color: doorColor);
}

// Percent sign: two rings + diagonal line
void drawPercent(img.Image image, int cx, int cy, int sz, img.Color color) {
  final r = sz * 17 ~/ 100;
  final sw = (sz * 0.09).toInt().clamp(2, 10);
  drawThickCircle(image, cx - sz * 22 ~/ 100, cy - sz * 22 ~/ 100, r, sw, color);
  drawThickCircle(image, cx + sz * 22 ~/ 100, cy + sz * 22 ~/ 100, r, sw, color);
  img.drawLine(image,
      x1: cx - sz * 28 ~/ 100, y1: cy + sz * 28 ~/ 100,
      x2: cx + sz * 28 ~/ 100, y2: cy - sz * 28 ~/ 100,
      color: color, thickness: sw);
}

// Plus sign
void drawPlus(img.Image image, int cx, int cy, int sz, img.Color color) {
  final w = (sz * 0.17).toInt().clamp(3, 18);
  final half = sz * 40 ~/ 100;
  img.fillRect(image, x1: cx - w ~/ 2, y1: cy - half, x2: cx + w ~/ 2, y2: cy + half, color: color);
  img.fillRect(image, x1: cx - half, y1: cy - w ~/ 2, x2: cx + half, y2: cy + w ~/ 2, color: color);
}

// Ascending 3-bar chart
void drawBarChart(img.Image image, int cx, int cy, int sz, img.Color color) {
  final bw = sz * 17 ~/ 100;
  final gap = sz * 8 ~/ 100;
  final totalW = bw * 3 + gap * 2;
  final x0 = cx - totalW ~/ 2;
  final bottom = cy + sz * 36 ~/ 100;
  final heights = [sz * 32 ~/ 100, sz * 52 ~/ 100, sz * 72 ~/ 100];
  for (int i = 0; i < 3; i++) {
    img.fillRect(image,
        x1: x0 + i * (bw + gap), y1: bottom - heights[i],
        x2: x0 + i * (bw + gap) + bw, y2: bottom, color: color);
  }
}

// Balance scale: pole + horizontal bar + two hanging pans
void drawScale(img.Image image, int cx, int cy, int sz, img.Color color) {
  final pw = (sz * 0.08).toInt().clamp(2, 8);
  // Pole
  img.fillRect(image, x1: cx - pw ~/ 2, y1: cy - sz * 40 ~/ 100,
      x2: cx + pw ~/ 2, y2: cy + sz * 36 ~/ 100, color: color);
  // Base triangle
  drawTriangle(image, cx, cy + sz * 24 ~/ 100, cy + sz * 38 ~/ 100, sz * 22 ~/ 100, color);
  // Horizontal arm
  img.fillRect(image, x1: cx - sz * 40 ~/ 100, y1: cy - sz * 28 ~/ 100,
      x2: cx + sz * 40 ~/ 100, y2: cy - sz * 28 ~/ 100 + pw, color: color);
  // Left pan chain + pan
  img.drawLine(image, x1: cx - sz * 38 ~/ 100, y1: cy - sz * 27 ~/ 100,
      x2: cx - sz * 38 ~/ 100, y2: cy + sz * 8 ~/ 100,
      color: color, thickness: pw ~/ 2);
  drawThickCircle(image, cx - sz * 38 ~/ 100, cy + sz * 14 ~/ 100, sz * 13 ~/ 100, pw ~/ 2, color);
  // Right pan chain + pan
  img.drawLine(image, x1: cx + sz * 38 ~/ 100, y1: cy - sz * 27 ~/ 100,
      x2: cx + sz * 38 ~/ 100, y2: cy + sz * 8 ~/ 100,
      color: color, thickness: pw ~/ 2);
  drawThickCircle(image, cx + sz * 38 ~/ 100, cy + sz * 14 ~/ 100, sz * 13 ~/ 100, pw ~/ 2, color);
}

// Graduation cap
void drawGradCap(img.Image image, int cx, int cy, int sz, img.Color color) {
  // Square cap top
  img.fillRect(image, x1: cx - sz * 29 ~/ 100, y1: cy - sz * 35 ~/ 100,
      x2: cx + sz * 29 ~/ 100, y2: cy - sz * 14 ~/ 100, color: color);
  // Wide brim
  img.fillRect(image, x1: cx - sz * 42 ~/ 100, y1: cy - sz * 16 ~/ 100,
      x2: cx + sz * 42 ~/ 100, y2: cy - sz * 6 ~/ 100, color: color);
  // Cylinder/head
  img.fillRect(image, x1: cx - sz * 25 ~/ 100, y1: cy - sz * 6 ~/ 100,
      x2: cx + sz * 25 ~/ 100, y2: cy + sz * 26 ~/ 100, color: color);
  // Tassel
  final sw = (sz * 0.07).toInt().clamp(2, 8);
  img.drawLine(image, x1: cx + sz * 29 ~/ 100, y1: cy - sz * 24 ~/ 100,
      x2: cx + sz * 29 ~/ 100, y2: cy + sz * 28 ~/ 100, color: color, thickness: sw);
  img.fillCircle(image, x: cx + sz * 29 ~/ 100, y: cy + sz * 28 ~/ 100,
      radius: sz * 7 ~/ 100, color: color);
}

// GPS pin (filled circle + downward triangle + white hole)
void drawGPSPin(img.Image image, int cx, int cy, int sz, img.Color color, img.Color holeColor) {
  final pinCy = cy - sz * 8 ~/ 100;
  final pinR = sz * 28 ~/ 100;
  img.fillCircle(image, x: cx, y: pinCy, radius: pinR, color: color);
  drawTriangle(image, cx, pinCy + pinR - sz * 5 ~/ 100, cy + sz * 40 ~/ 100, pinR * 55 ~/ 100, color);
  img.fillCircle(image, x: cx, y: pinCy, radius: pinR * 44 ~/ 100, color: holeColor);
}

// Key: ring + shaft + two teeth
void drawKey(img.Image image, int cx, int cy, int sz, img.Color color) {
  final kx = cx - sz * 12 ~/ 100;
  final ky = cy - sz * 5 ~/ 100;
  final rr = sz * 22 ~/ 100;
  final sw = (sz * 0.09).toInt().clamp(3, 12);
  drawThickCircle(image, kx, ky, rr, sw, color);
  final sh = sz * 11 ~/ 100;
  final shx0 = kx + rr - sw ~/ 2;
  final shx1 = cx + sz * 42 ~/ 100;
  img.fillRect(image, x1: shx0, y1: ky - sh ~/ 2, x2: shx1, y2: ky + sh ~/ 2, color: color);
  final tw = sz * 8 ~/ 100;
  final th = sz * 11 ~/ 100;
  for (final frac in [45, 68]) {
    final tx = shx0 + (shx1 - shx0) * frac ~/ 100;
    img.fillRect(image, x1: tx, y1: ky + sh ~/ 2, x2: tx + tw, y2: ky + sh ~/ 2 + th, color: color);
  }
}

// Receipt: rounded rect + horizontal lines
void drawReceipt(img.Image image, int cx, int cy, int sz, img.Color rectColor, img.Color lineColor) {
  final rw = sz * 60 ~/ 100;
  final rh = sz * 72 ~/ 100;
  drawRoundedRect(image, cx - rw ~/ 2, cy - rh ~/ 2, rw, rh, sz * 6 ~/ 100, rectColor);
  final lw = rw * 66 ~/ 100;
  final lh = (sz * 0.055).toInt().clamp(2, 6);
  for (int i = 1; i <= 4; i++) {
    final ly = cy - rh ~/ 2 + rh * i ~/ 5 - lh ~/ 2;
    img.fillRect(image, x1: cx - lw ~/ 2, y1: ly, x2: cx + lw ~/ 2, y2: ly + lh, color: lineColor);
  }
}

// Car: body rect + cab rect + two wheels
void drawCar(img.Image image, int cx, int cy, int sz, img.Color color) {
  final bw = sz * 75 ~/ 100;
  final bh = sz * 24 ~/ 100;
  final bt = cy - sz * 6 ~/ 100;
  img.fillRect(image, x1: cx - bw ~/ 2, y1: bt, x2: cx + bw ~/ 2, y2: bt + bh, color: color);
  img.fillRect(image, x1: cx - sz * 24 ~/ 100, y1: bt - sz * 20 ~/ 100,
      x2: cx + sz * 24 ~/ 100, y2: bt, color: color);
  final wr = sz * 13 ~/ 100;
  img.fillCircle(image, x: cx - bw * 26 ~/ 100, y: bt + bh, radius: wr, color: color);
  img.fillCircle(image, x: cx + bw * 26 ~/ 100, y: bt + bh, radius: wr, color: color);
}

// Building: stacked floor rects
void drawBuilding(img.Image image, int cx, int cy, int sz, img.Color color) {
  final bw = sz * 50 ~/ 100;
  final fh = sz * 14 ~/ 100;
  final bottom = cy + sz * 36 ~/ 100;
  for (int i = 0; i < 4; i++) {
    final fy = bottom - (i + 1) * (fh + 2) + 2;
    img.fillRect(image, x1: cx - bw ~/ 2, y1: fy, x2: cx + bw ~/ 2, y2: fy + fh, color: color);
  }
}

// Document: rounded rect + lines (tax forms)
void drawDocument(img.Image image, int cx, int cy, int sz, img.Color rectColor, img.Color lineColor) {
  final dw = sz * 60 ~/ 100;
  final dh = sz * 74 ~/ 100;
  drawRoundedRect(image, cx - dw ~/ 2, cy - dh ~/ 2, dw, dh, sz * 5 ~/ 100, rectColor);
  final lw = dw * 64 ~/ 100;
  final lh = (sz * 0.06).toInt().clamp(2, 6);
  for (int i = 1; i <= 5; i++) {
    final ly = cy - dh ~/ 2 + dh * i ~/ 6 - lh ~/ 2;
    img.fillRect(image, x1: cx - lw ~/ 2, y1: ly, x2: cx + lw ~/ 2, y2: ly + lh, color: lineColor);
  }
}

// Credit card: rounded rect + stripe + chip
void drawCreditCard(img.Image image, int cx, int cy, int sz, img.Color cardColor, img.Color stripeColor) {
  final cw = sz * 76 ~/ 100;
  final ch = sz * 50 ~/ 100;
  drawRoundedRect(image, cx - cw ~/ 2, cy - ch ~/ 2, cw, ch, sz * 7 ~/ 100, cardColor);
  final stripeH = ch * 20 ~/ 100;
  img.fillRect(image, x1: cx - cw ~/ 2, y1: cy - ch * 12 ~/ 100,
      x2: cx + cw ~/ 2, y2: cy - ch * 12 ~/ 100 + stripeH, color: stripeColor);
  // Chip
  drawRoundedRect(image, cx - cw * 30 ~/ 100, cy + ch * 5 ~/ 100,
      cw * 22 ~/ 100, ch * 30 ~/ 100, sz * 3 ~/ 100,
      img.ColorRgba8(255, 215, 0, 200));
}

// Coin ring + $ inside
void drawCoin(img.Image image, int cx, int cy, int sz, img.Color color) {
  final coinR = sz * 32 ~/ 100;
  final sw = (sz * 0.055).toInt().clamp(3, 12);
  img.fillCircle(image, x: cx, y: cy, radius: coinR, color: img.ColorRgba8(255, 255, 255, 30));
  drawThickCircle(image, cx, cy, coinR, sw, color);
  drawDollarSign(image, cx, cy, coinR, color);
}

// House with % badge in bottom-right corner
void drawHouseWithPercent(img.Image image, int cx, int cy, int sz, img.Color bodyColor,
    img.Color doorColor, img.Color badgeBg) {
  drawHouse(image, cx - sz * 8 ~/ 100, cy, sz * 88 ~/ 100, bodyColor, doorColor);
  // Badge
  final badgeCx = cx + sz * 30 ~/ 100;
  final badgeCy = cy + sz * 28 ~/ 100;
  final badgeR = sz * 20 ~/ 100;
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR + sz * 2 ~/ 100,
      color: img.ColorRgba8(255, 255, 255, 255));
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR, color: badgeBg);
  drawPercent(image, badgeCx, badgeCy, badgeR, img.ColorRgba8(255, 255, 255, 255));
}

// House with $ coin badge
void drawHouseWithCoin(img.Image image, int cx, int cy, int sz, img.Color bodyColor,
    img.Color doorColor, img.Color badgeBg) {
  drawHouse(image, cx - sz * 8 ~/ 100, cy, sz * 88 ~/ 100, bodyColor, doorColor);
  final badgeCx = cx + sz * 30 ~/ 100;
  final badgeCy = cy + sz * 28 ~/ 100;
  final badgeR = sz * 20 ~/ 100;
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR + sz * 2 ~/ 100,
      color: img.ColorRgba8(255, 255, 255, 255));
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR, color: badgeBg);
  final sw = (badgeR * 0.055).toInt().clamp(1, 4);
  drawThickCircle(image, badgeCx, badgeCy, badgeR * 72 ~/ 100, sw,
      img.ColorRgba8(255, 255, 255, 255));
  drawDollarSign(image, badgeCx, badgeCy, badgeR * 60 ~/ 100,
      img.ColorRgba8(255, 255, 255, 255));
}

// House with + badge
void drawHouseWithPlus(img.Image image, int cx, int cy, int sz, img.Color bodyColor,
    img.Color doorColor, img.Color badgeBg) {
  drawHouse(image, cx - sz * 8 ~/ 100, cy, sz * 88 ~/ 100, bodyColor, doorColor);
  final badgeCx = cx + sz * 30 ~/ 100;
  final badgeCy = cy + sz * 28 ~/ 100;
  final badgeR = sz * 20 ~/ 100;
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR + sz * 2 ~/ 100,
      color: img.ColorRgba8(255, 255, 255, 255));
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR, color: badgeBg);
  drawPlus(image, badgeCx, badgeCy, badgeR, img.ColorRgba8(255, 255, 255, 255));
}

// ─── RentBuyUS — teal: house (left) | coin (right) ──────────────────────────
img.Image createRentBuyIcon(int size) {
  final s = size;
  final teal = img.ColorRgba8(0, 137, 123, 255);
  final tealDark = img.ColorRgba8(0, 77, 64, 255);
  final white = img.ColorRgba8(255, 255, 255, 255);
  final whiteAlpha = img.ColorRgba8(255, 255, 255, 50);

  final image = img.Image(width: s, height: s);
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));
  drawRoundedRect(image, 0, 0, s - 1, s - 1, s ~/ 5, teal);

  final hCx = s * 30 ~/ 100;
  final houseW = s * 38 ~/ 100;
  final houseBodyH = s * 26 ~/ 100;
  final houseBodyTop = s * 50 ~/ 100;
  drawTriangle(image, hCx, s * 24 ~/ 100, houseBodyTop, houseW ~/ 2, white);
  img.fillRect(image, x1: hCx - houseW ~/ 2, y1: houseBodyTop,
      x2: hCx + houseW ~/ 2, y2: houseBodyTop + houseBodyH, color: white);
  final dw = houseW * 28 ~/ 100;
  final dh = houseBodyH * 55 ~/ 100;
  img.fillRect(image, x1: hCx - dw ~/ 2, y1: houseBodyTop + houseBodyH - dh,
      x2: hCx + dw ~/ 2, y2: houseBodyTop + houseBodyH, color: tealDark);

  img.fillRect(image, x1: s ~/ 2 - 1, y1: s * 20 ~/ 100,
      x2: s ~/ 2 + 1, y2: s * 80 ~/ 100, color: whiteAlpha);

  final cCx = s * 70 ~/ 100;
  final cCy = s * 51 ~/ 100;
  final coinR = s * 20 ~/ 100;
  final sw2 = (s * 0.045).toInt().clamp(2, 8);
  img.fillCircle(image, x: cCx, y: cCy, radius: coinR,
      color: img.ColorRgba8(255, 255, 255, 35));
  drawThickCircle(image, cCx, cCy, coinR, sw2, white);
  final vw = (coinR * 0.22).toInt().clamp(2, 8);
  final bw = (coinR * 0.90).toInt();
  final bh = vw;
  img.fillRect(image, x1: cCx - vw ~/ 2, y1: cCy - coinR * 60 ~/ 100,
      x2: cCx + vw ~/ 2, y2: cCy + coinR * 60 ~/ 100, color: white);
  for (final dy in [-(coinR * 35 ~/ 100), 0, coinR * 35 ~/ 100]) {
    img.fillRect(image, x1: cCx - bw, y1: cCy + dy - bh ~/ 2,
        x2: cCx + bw, y2: cCy + dy + bh ~/ 2, color: white);
  }
  return image;
}

// ─── LoanPayoffUS — deep purple: coin + green check badge ───────────────────
img.Image createLoanPayoffIcon(int size) {
  final s = size;
  final purple = img.ColorRgba8(81, 45, 168, 255);
  final purpleDark = img.ColorRgba8(49, 27, 146, 255);
  final white = img.ColorRgba8(255, 255, 255, 255);
  final green = img.ColorRgba8(67, 160, 71, 255);

  final image = img.Image(width: s, height: s);
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));
  drawRoundedRect(image, 0, 0, s - 1, s - 1, s ~/ 5, purpleDark);
  drawRoundedRect(image, 0, 0, s - 1, s * 55 ~/ 100, s ~/ 5, purple);

  final cx = s ~/ 2;
  final cy = s * 46 ~/ 100;
  final coinR = s * 30 ~/ 100;
  final sw = (s * 0.055).toInt().clamp(3, 12);
  img.fillCircle(image, x: cx, y: cy, radius: coinR,
      color: img.ColorRgba8(255, 255, 255, 28));
  drawThickCircle(image, cx, cy, coinR, sw, white);
  final vw = (coinR * 0.20).toInt().clamp(2, 10);
  final bw2 = (coinR * 0.68).toInt();
  final bh2 = vw;
  img.fillRect(image, x1: cx - vw ~/ 2, y1: cy - coinR * 58 ~/ 100,
      x2: cx + vw ~/ 2, y2: cy + coinR * 58 ~/ 100, color: white);
  for (final dy in [-(coinR * 35 ~/ 100), 0, coinR * 35 ~/ 100]) {
    img.fillRect(image, x1: cx - bw2, y1: cy + dy - bh2 ~/ 2,
        x2: cx + bw2, y2: cy + dy + bh2 ~/ 2, color: white);
  }

  final badgeCx = cx + coinR * 62 ~/ 100;
  final badgeCy = cy + coinR * 62 ~/ 100;
  final badgeR = s * 18 ~/ 100;
  img.fillCircle(image, x: badgeCx, y: badgeCy,
      radius: badgeR + (s * 0.02).toInt(), color: white);
  img.fillCircle(image, x: badgeCx, y: badgeCy, radius: badgeR, color: green);
  drawCheck(image, badgeCx, badgeCy - badgeR * 5 ~/ 100, badgeR, white);
  return image;
}

// ─── Icon factory helper ─────────────────────────────────────────────────────
img.Image _make(int sz, img.Color bg, void Function(img.Image im, int cx, int cy, int s) draw) {
  final image = img.Image(width: sz, height: sz);
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));
  drawRoundedRect(image, 0, 0, sz - 1, sz - 1, sz ~/ 5, bg);
  draw(image, sz ~/ 2, sz ~/ 2, sz);
  return image;
}

// Shorthand colors
img.Color _c(int r, int g, int b) => img.ColorRgba8(r, g, b, 255);
final white = img.ColorRgba8(255, 255, 255, 255);

// ─── MortgageCA — red, house + $ coin badge ──────────────────────────────────
img.Image createMortgageCAIcon(int sz) => _make(sz, _c(183, 28, 28), (im, cx, cy, s) {
      drawHouseWithCoin(im, cx, cy, s, white, _c(183, 28, 28), _c(198, 40, 40));
    });

// ─── MortgageUS — blue, house + $ coin badge ────────────────────────────────
img.Image createMortgageUSIcon(int sz) => _make(sz, _c(21, 101, 192), (im, cx, cy, s) {
      drawHouseWithCoin(im, cx, cy, s, white, _c(21, 101, 192), _c(13, 71, 161));
    });

// ─── MortgageUK — purple, house + $ coin badge ──────────────────────────────
img.Image createMortgageUKIcon(int sz) => _make(sz, _c(106, 27, 154), (im, cx, cy, s) {
      drawHouseWithCoin(im, cx, cy, s, white, _c(106, 27, 154), _c(74, 20, 140));
    });

// ─── MortgageExtraPayment — dark green, house + plus badge ──────────────────
img.Image createMortgageExtraPaymentIcon(int sz) => _make(sz, _c(27, 94, 32), (im, cx, cy, s) {
      drawHouseWithPlus(im, cx, cy, s, white, _c(27, 94, 32), _c(46, 125, 50));
    });

// ─── AutoLoan — deep orange, car ────────────────────────────────────────────
img.Image createAutoLoanIcon(int sz) => _make(sz, _c(230, 81, 0), (im, cx, cy, s) {
      drawCar(im, cx, cy, s, white);
    });

// ─── AffordabilityCA — forest green, balance scale ──────────────────────────
img.Image createAffordabilityCAIcon(int sz) => _make(sz, _c(46, 125, 50), (im, cx, cy, s) {
      drawScale(im, cx, cy, s, white);
    });

// ─── AffordabilityUS — indigo, balance scale ────────────────────────────────
img.Image createAffordabilityUSIcon(int sz) => _make(sz, _c(40, 53, 147), (im, cx, cy, s) {
      drawScale(im, cx, cy, s, white);
    });

// ─── AffordabilityUK — dark blue, balance scale ─────────────────────────────
img.Image createAffordabilityUKIcon(int sz) => _make(sz, _c(1, 87, 155), (im, cx, cy, s) {
      drawScale(im, cx, cy, s, white);
    });

// ─── HELOCApp — brown, house + horizontal equity bar ────────────────────────
img.Image createHELOCIcon(int sz) => _make(sz, _c(78, 52, 46), (im, cx, cy, s) {
      // Shift house up a little, draw equity bar below
      drawHouse(im, cx, cy - s * 6 ~/ 100, s, white, _c(78, 52, 46));
      // Equity bar (% fill)
      final barW = s * 62 ~/ 100;
      final barH = s * 10 ~/ 100;
      final barY = cy + s * 32 ~/ 100;
      drawRoundedRect(im, cx - barW ~/ 2, barY, barW, barH, barH ~/ 2,
          img.ColorRgba8(255, 255, 255, 60));
      drawRoundedRect(im, cx - barW ~/ 2, barY, barW * 65 ~/ 100, barH, barH ~/ 2, white);
    });

// ─── RefinanceApp — magenta, two coins with arrow ───────────────────────────
img.Image createRefinanceIcon(int sz) => _make(sz, _c(136, 14, 79), (im, cx, cy, s) {
      // Left coin
      drawThickCircle(im, cx - s * 22 ~/ 100, cy, s * 22 ~/ 100,
          (s * 0.055).toInt().clamp(2, 10), white);
      // Right coin
      drawThickCircle(im, cx + s * 22 ~/ 100, cy, s * 22 ~/ 100,
          (s * 0.055).toInt().clamp(2, 10), white);
      // Right arrow between them
      final sw = (s * 0.09).toInt().clamp(2, 10);
      img.drawLine(im, x1: cx - s * 8 ~/ 100, y1: cy,
          x2: cx + s * 8 ~/ 100, y2: cy, color: white, thickness: sw);
      img.drawLine(im, x1: cx + s * 3 ~/ 100, y1: cy - s * 8 ~/ 100,
          x2: cx + s * 8 ~/ 100, y2: cy, color: white, thickness: sw);
      img.drawLine(im, x1: cx + s * 3 ~/ 100, y1: cy + s * 8 ~/ 100,
          x2: cx + s * 8 ~/ 100, y2: cy, color: white, thickness: sw);
    });

// ─── PropertyROI — dark teal, building + % badge ────────────────────────────
img.Image createPropertyROIIcon(int sz) => _make(sz, _c(0, 105, 92), (im, cx, cy, s) {
      drawBuilding(im, cx - s * 8 ~/ 100, cy, s, white);
      final badgeCx = cx + s * 30 ~/ 100;
      final badgeCy = cy - s * 24 ~/ 100;
      final badgeR = s * 20 ~/ 100;
      img.fillCircle(im, x: badgeCx, y: badgeCy, radius: badgeR + s * 2 ~/ 100, color: white);
      img.fillCircle(im, x: badgeCx, y: badgeCy, radius: badgeR, color: _c(0, 77, 64));
      drawPercent(im, badgeCx, badgeCy, badgeR, white);
    });

// ─── StudentLoan — navy, graduation cap ─────────────────────────────────────
img.Image createStudentLoanIcon(int sz) => _make(sz, _c(26, 35, 126), (im, cx, cy, s) {
      drawGradCap(im, cx, cy, s, white);
    });

// ─── rideprofit — dark green, GPS pin ───────────────────────────────────────
img.Image createRideProfitIcon(int sz) => _make(sz, _c(27, 94, 32), (im, cx, cy, s) {
      drawGPSPin(im, cx, cy, s, white, _c(27, 94, 32));
    });

// ─── CreditCardAPR — crimson, credit card ───────────────────────────────────
img.Image createCreditCardIcon(int sz) => _make(sz, _c(183, 28, 28), (im, cx, cy, s) {
      drawCreditCard(im, cx, cy, s, white, _c(183, 28, 28));
    });

// ─── SalaryApp — green, large $ sign ────────────────────────────────────────
img.Image createSalaryIcon(int sz) => _make(sz, _c(56, 142, 60), (im, cx, cy, s) {
      drawDollarSign(im, cx, cy, s * 48 ~/ 100, white);
    });

// ─── RentalROI — teal, house + % badge ──────────────────────────────────────
img.Image createRentalROIIcon(int sz) => _make(sz, _c(0, 121, 107), (im, cx, cy, s) {
      drawHouseWithPercent(im, cx, cy, s, white, _c(0, 121, 107), _c(0, 77, 64));
    });

// ─── LandlordCashFlow — amber-brown, key + bar chart ────────────────────────
img.Image createLandlordCashFlowIcon(int sz) => _make(sz, _c(191, 84, 0), (im, cx, cy, s) {
      drawKey(im, cx, cy - s * 8 ~/ 100, s, white);
      drawBarChart(im, cx, cy + s * 28 ~/ 100, s * 45 ~/ 100, white);
    });

// ─── HouseFlip — pink-red, house with left/right arrows ─────────────────────
img.Image createHouseFlipIcon(int sz) => _make(sz, _c(173, 20, 87), (im, cx, cy, s) {
      drawHouse(im, cx, cy - s * 5 ~/ 100, s * 72 ~/ 100, white, _c(173, 20, 87));
      final sw = (s * 0.08).toInt().clamp(2, 10);
      // Left arrow
      img.drawLine(im, x1: cx - s * 38 ~/ 100, y1: cy + s * 28 ~/ 100,
          x2: cx - s * 20 ~/ 100, y2: cy + s * 28 ~/ 100, color: white, thickness: sw);
      img.drawLine(im, x1: cx - s * 30 ~/ 100, y1: cy + s * 22 ~/ 100,
          x2: cx - s * 38 ~/ 100, y2: cy + s * 28 ~/ 100, color: white, thickness: sw);
      img.drawLine(im, x1: cx - s * 30 ~/ 100, y1: cy + s * 34 ~/ 100,
          x2: cx - s * 38 ~/ 100, y2: cy + s * 28 ~/ 100, color: white, thickness: sw);
      // Right arrow
      img.drawLine(im, x1: cx + s * 20 ~/ 100, y1: cy + s * 28 ~/ 100,
          x2: cx + s * 38 ~/ 100, y2: cy + s * 28 ~/ 100, color: white, thickness: sw);
      img.drawLine(im, x1: cx + s * 30 ~/ 100, y1: cy + s * 22 ~/ 100,
          x2: cx + s * 38 ~/ 100, y2: cy + s * 28 ~/ 100, color: white, thickness: sw);
      img.drawLine(im, x1: cx + s * 30 ~/ 100, y1: cy + s * 34 ~/ 100,
          x2: cx + s * 38 ~/ 100, y2: cy + s * 28 ~/ 100, color: white, thickness: sw);
    });

// ─── CapRate — slate, building + ascending bars ──────────────────────────────
img.Image createCapRateIcon(int sz) => _make(sz, _c(38, 50, 56), (im, cx, cy, s) {
      drawBuilding(im, cx - s * 12 ~/ 100, cy, s, white);
      drawBarChart(im, cx + s * 22 ~/ 100, cy + s * 5 ~/ 100, s * 55 ~/ 100, white);
    });

// ─── BRRRRCalc — blue, house + 4 dots (cycle) ───────────────────────────────
img.Image createBRRRRIcon(int sz) => _make(sz, _c(13, 71, 161), (im, cx, cy, s) {
      drawHouse(im, cx, cy - s * 6 ~/ 100, s * 70 ~/ 100, white, _c(13, 71, 161));
      // 4 dots around house representing BRRRR cycle
      final dotR = s * 7 ~/ 100;
      final dist = s * 38 ~/ 100;
      final positions = [
        [cx, cy - dist],           // top
        [cx + dist, cy],           // right
        [cx, cy + dist * 80 ~/ 100], // bottom
        [cx - dist, cy],           // left
      ];
      for (final p in positions) {
        img.fillCircle(im, x: p[0], y: p[1], radius: dotR, color: white);
      }
    });

// ─── RentalExpenses — blue-grey, receipt/list ───────────────────────────────
img.Image createRentalExpensesIcon(int sz) => _make(sz, _c(55, 71, 79), (im, cx, cy, s) {
      drawReceipt(im, cx, cy, s, white, _c(55, 71, 79));
    });

// ─── RentalROI — already created above ──────────────────────────────────────

// ─── TaxUS — dark blue, document + $ symbol ─────────────────────────────────
img.Image createTaxUSIcon(int sz) => _make(sz, _c(26, 35, 126), (im, cx, cy, s) {
      drawDocument(im, cx, cy, s, white, _c(26, 35, 126));
      drawDollarSign(im, cx, cy + s * 8 ~/ 100, s * 30 ~/ 100, _c(26, 35, 126));
    });

// ─── TaxAU — gold/amber, document ────────────────────────────────────────────
img.Image createTaxAUIcon(int sz) => _make(sz, _c(245, 127, 23), (im, cx, cy, s) {
      drawDocument(im, cx, cy, s, white, _c(245, 127, 23));
    });

// ─── TaxeUK — royal blue, document ───────────────────────────────────────────
img.Image createTaxeUKIcon(int sz) => _make(sz, _c(13, 71, 161), (im, cx, cy, s) {
      drawDocument(im, cx, cy, s, white, _c(13, 71, 161));
    });

// ─── RideProfit — dark green is same bg as AffordabilityCA — adjust ──────────
// Note: rideprofit uses _c(27,94,32) bg, AffordabilityCA uses _c(46,125,50) — OK

// ─── Save helpers ─────────────────────────────────────────────────────────────
final densities = {
  'mipmap-mdpi': 48,
  'mipmap-hdpi': 72,
  'mipmap-xhdpi': 96,
  'mipmap-xxhdpi': 144,
  'mipmap-xxxhdpi': 192,
};

// Flutter app: android/app/src/main/res/
void saveIcon(img.Image icon, String appPath, String density) {
  final dir = Directory('$appPath/android/app/src/main/res/$density');
  dir.createSync(recursive: true);
  final bytes = img.encodePng(icon);
  File('${dir.path}/ic_launcher.png').writeAsBytesSync(bytes);
  File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(bytes);
}

// Native Android app: app/src/main/res/
void saveIconNative(img.Image icon, String appPath, String density) {
  final dir = Directory('$appPath/app/src/main/res/$density');
  dir.createSync(recursive: true);
  final bytes = img.encodePng(icon);
  File('${dir.path}/ic_launcher.png').writeAsBytesSync(bytes);
  File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(bytes);
}

void genApp(String label, String appPath, img.Image Function(int) creator,
    {bool native = false}) {
  print('\n>>> $label');
  for (final e in densities.entries) {
    final icon = creator(e.value);
    if (native) {
      saveIconNative(icon, appPath, e.key);
    } else {
      saveIcon(icon, appPath, e.key);
    }
    print('  ✓ ${e.key} (${e.value}px)');
  }
}

// ─── Main ─────────────────────────────────────────────────────────────────────
void main() {
  const base = 'D:/mob';

  print('==============================');
  print(' Icon Generator — 26 apps');
  print('==============================');

  // Flutter apps
  genApp('RentBuyUS',             '$base/RentBuyUS',             createRentBuyIcon);
  genApp('LoanPayoffUS',          '$base/LoanPayoffUS',          createLoanPayoffIcon);
  genApp('MortgageCA',            '$base/MortgageCA',            createMortgageCAIcon);
  genApp('MortgageUS',            '$base/MortgageUS',            createMortgageUSIcon);
  genApp('MortgageUK',            '$base/MortgageUK',            createMortgageUKIcon);
  genApp('MortgageExtraPayment',  '$base/MortgageExtraPayment',  createMortgageExtraPaymentIcon);
  genApp('AutoLoan',              '$base/AutoLoan',              createAutoLoanIcon);
  genApp('AffordabilityCA',       '$base/AffordabilityCA',       createAffordabilityCAIcon);
  genApp('AffordabilityUS',       '$base/AffordabilityUS',       createAffordabilityUSIcon);
  genApp('AffordabilityUK',       '$base/AffordabilityUK',       createAffordabilityUKIcon);
  genApp('HELOCApp',              '$base/HELOCApp',              createHELOCIcon);
  genApp('RefinanceApp',          '$base/RefinanceApp',          createRefinanceIcon);
  genApp('PropertyROI',           '$base/PropertyROI',           createPropertyROIIcon);
  genApp('StudentLoan',           '$base/StudentLoan',           createStudentLoanIcon);
  genApp('rideprofit',            '$base/rideprofit',            createRideProfitIcon);
  genApp('CreditCardAPR',         '$base/CreditCardAPR',         createCreditCardIcon);
  genApp('SalaryApp',             '$base/SalaryApp',             createSalaryIcon);
  genApp('RentalROI',             '$base/RentalROI',             createRentalROIIcon);
  genApp('LandlordCashFlow',      '$base/LandlordCashFlow',      createLandlordCashFlowIcon);
  genApp('HouseFlip',             '$base/HouseFlip',             createHouseFlipIcon);
  genApp('CapRate',               '$base/CapRate',               createCapRateIcon);
  genApp('BRRRRCalc',             '$base/BRRRRCalc',             createBRRRRIcon);
  genApp('RentalExpenses',        '$base/RentalExpenses',        createRentalExpensesIcon);

  // Native Android apps
  genApp('TaxUS',   '$base/TaxUS',   createTaxUSIcon,   native: true);
  genApp('TaxAU',   '$base/TaxAU',   createTaxAUIcon,   native: true);
  genApp('TaxeUK',  '$base/TaxeUK',  createTaxeUKIcon,  native: true);

  print('\n==============================');
  print(' Done! 26 apps iconified.');
  print('==============================');
}
