#!/usr/bin/env swift
import AppKit
import CoreGraphics

let iconSize: CGFloat = 1024
let img = NSImage(size: NSSize(width: iconSize, height: iconSize))
img.lockFocus()
guard let ctx = NSGraphicsContext.current?.cgContext else { exit(1) }

// ── Background ────────────────────────────────────────────────────────────────
ctx.setFillColor(CGColor(srgbRed: 0.960, green: 0.978, blue: 0.970, alpha: 1))
ctx.fill(CGRect(x: 0, y: 0, width: iconSize, height: iconSize))

let cx = iconSize / 2   // 512
let cy = iconSize / 2   // 512

// ── Rotate 10° clockwise (leaf leans right) ───────────────────────────────────
ctx.saveGState()
ctx.translateBy(x: cx, y: cy)
ctx.rotate(by: -0.175)
ctx.translateBy(x: -cx, y: -cy)

// ── Leaf geometry ─────────────────────────────────────────────────────────────
let btm = CGPoint(x: cx, y: cy - 295)   // lower tip (stem joins here)
let top = CGPoint(x: cx, y: cy + 390)   // upper tip
let w: CGFloat = 340                     // horizontal reach of control points

let leafPath = CGMutablePath()
leafPath.move(to: btm)
leafPath.addCurve(to: top,
                  control1: CGPoint(x: cx + w,        y: cy - 75),
                  control2: CGPoint(x: cx + w * 0.70, y: cy + 265))
leafPath.addCurve(to: btm,
                  control1: CGPoint(x: cx - w * 0.70, y: cy + 265),
                  control2: CGPoint(x: cx - w,        y: cy - 75))
leafPath.closeSubpath()

// ── Drop shadow + base fill (shadow is rendered here, gradient paints over it) ─
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 6, height: -14), blur: 30,
              color: CGColor(srgbRed: 0.06, green: 0.22, blue: 0.14, alpha: 0.28))
ctx.addPath(leafPath)
ctx.setFillColor(CGColor(srgbRed: 0.17, green: 0.42, blue: 0.30, alpha: 1))
ctx.fillPath()
ctx.restoreGState()

// ── Gradient fill: dark forest green → fresh leaf green ───────────────────────
ctx.saveGState()
ctx.addPath(leafPath)
ctx.clip()
let colorSpace = CGColorSpaceCreateDeviceRGB()
let gradient = CGGradient(
    colorsSpace: colorSpace,
    colors: [
        CGColor(srgbRed: 0.173, green: 0.416, blue: 0.306, alpha: 1),  // #2C6A4E — bottom
        CGColor(srgbRed: 0.455, green: 0.776, blue: 0.596, alpha: 1),  // #74C698 — top
    ] as CFArray,
    locations: [0.0, 1.0]
)!
ctx.drawLinearGradient(gradient, start: btm, end: top, options: [])
ctx.restoreGState()

// ── Leaf outline (subtle dark edge) ──────────────────────────────────────────
ctx.saveGState()
ctx.addPath(leafPath)
ctx.setStrokeColor(CGColor(srgbRed: 0.086, green: 0.298, blue: 0.196, alpha: 0.40))
ctx.setLineWidth(4)
ctx.strokePath()
ctx.restoreGState()

// ── Center vein ───────────────────────────────────────────────────────────────
ctx.saveGState()
ctx.setStrokeColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.30))
ctx.setLineWidth(5)
ctx.setLineCap(.round)
ctx.move(to: CGPoint(x: cx, y: btm.y + 30))
ctx.addLine(to: CGPoint(x: cx, y: top.y - 65))
ctx.strokePath()
ctx.restoreGState()

// ── Lateral veins ─────────────────────────────────────────────────────────────
// (y, angle-from-horizontal-rad, length, lineWidth)
let veins: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (cy - 155, 0.50, 138, 3.5),
    (cy -  55, 0.47, 152, 3.5),
    (cy +  50, 0.44, 142, 3.0),
    (cy + 148, 0.40, 122, 2.5),
    (cy + 238, 0.34,  95, 2.0),
]
ctx.saveGState()
ctx.setStrokeColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.25))
ctx.setLineCap(.round)
for (vy, angle, len, lw) in veins {
    ctx.setLineWidth(lw)
    let dx = cos(angle) * len
    let dy = sin(angle) * len
    ctx.move(to: CGPoint(x: cx, y: vy));      ctx.addLine(to: CGPoint(x: cx + dx, y: vy + dy))
    ctx.move(to: CGPoint(x: cx, y: vy));      ctx.addLine(to: CGPoint(x: cx - dx, y: vy + dy))
    ctx.strokePath()
}
ctx.restoreGState()

// ── Stem ─────────────────────────────────────────────────────────────────────
ctx.saveGState()
let stemW: CGFloat = 24
let stemH: CGFloat = 95
let stemRect = CGRect(x: cx - stemW/2, y: btm.y - stemH, width: stemW, height: stemH + 8)
ctx.setFillColor(CGColor(srgbRed: 0.086, green: 0.255, blue: 0.176, alpha: 1))
ctx.addPath(CGPath(roundedRect: stemRect, cornerWidth: stemW/2, cornerHeight: stemW/2, transform: nil))
ctx.fillPath()
ctx.restoreGState()

// ── Restore rotation ──────────────────────────────────────────────────────────
ctx.restoreGState()

// ── Encode and save ───────────────────────────────────────────────────────────
img.unlockFocus()
guard let tiff   = img.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let png    = bitmap.representation(using: .png, properties: [:])
else { print("PNG error"); exit(1) }

try! png.write(to: URL(fileURLWithPath: "/tmp/leaflet-icon-1024.png"))
print("✓ Saved /tmp/leaflet-icon-1024.png")
