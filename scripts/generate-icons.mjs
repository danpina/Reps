/**
 * Generates the PWA icons from a single vector definition.
 *
 * The mark is a tally of five — four strokes and a diagonal — because that is
 * literally what the app records. It reads at 48px on a home screen, which
 * rules out anything more detailed.
 *
 * Run with: node scripts/generate-icons.mjs
 */

import { mkdir, writeFile } from "node:fs/promises";
import { join } from "node:path";
import sharp from "sharp";

const PUBLIC = join(import.meta.dirname, "..", "public");

const INK = "#101214";
const ACCENT = "#8fb397";

/**
 * @param {object} options
 * @param {number} options.scale  Content size as a fraction of the canvas.
 * @param {number} options.radius Corner radius in viewBox units, 0 for full bleed.
 */
function svg({ scale, radius }) {
  const size = 512;
  const center = size / 2;

  // The mark is drawn in its own 512 space, then scaled about the centre.
  const strokeWidth = 26;
  const top = 168;
  const bottom = 344;
  const xs = [172, 228, 284, 340];

  const marks = [
    ...xs.map(
      (x) =>
        `<line x1="${x}" y1="${top}" x2="${x}" y2="${bottom}" />`,
    ),
    `<line x1="150" y1="352" x2="362" y2="160" />`,
  ].join("");

  const background =
    radius > 0
      ? `<rect width="${size}" height="${size}" rx="${radius}" fill="${INK}" />`
      : `<rect width="${size}" height="${size}" fill="${INK}" />`;

  return Buffer.from(`<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  ${background}
  <g transform="translate(${center} ${center}) scale(${scale}) translate(${-center} ${-center})"
     stroke="${ACCENT}" stroke-width="${strokeWidth}" stroke-linecap="round" fill="none">
    ${marks}
  </g>
</svg>`);
}

const targets = [
  // Standard icons keep their own rounded corners.
  { file: "icon-192.png", size: 192, scale: 1, radius: 112 },
  { file: "icon-512.png", size: 512, scale: 1, radius: 112 },
  // Maskable icons are cropped by the OS, so the background must be full bleed
  // and the mark must sit inside the safe zone.
  { file: "icon-maskable-192.png", size: 192, scale: 0.62, radius: 0 },
  { file: "icon-maskable-512.png", size: 512, scale: 0.62, radius: 0 },
  // iOS does not respect transparency or masking, so it gets a square.
  { file: "apple-touch-icon.png", size: 180, scale: 0.86, radius: 0 },
];

await mkdir(PUBLIC, { recursive: true });

for (const { file, size, scale, radius } of targets) {
  const png = await sharp(svg({ scale, radius }))
    .resize(size, size)
    .png()
    .toBuffer();
  await writeFile(join(PUBLIC, file), png);
  console.log(`wrote public/${file} (${size}x${size})`);
}

// A vector favicon for browsers that prefer one.
await writeFile(join(PUBLIC, "icon.svg"), svg({ scale: 1, radius: 112 }));
console.log("wrote public/icon.svg");
