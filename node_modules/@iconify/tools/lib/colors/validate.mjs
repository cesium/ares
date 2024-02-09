import { colorToString } from '@iconify/utils/lib/colors';
import { parseColors, parseColorsSync } from './parse.mjs';
import '../svg/data/tags.mjs';
import '../svg/parse-style.mjs';
import '../css/parse.mjs';
import '../css/parser/tokens.mjs';
import '../css/parser/error.mjs';
import '../css/parser/strings.mjs';
import '../css/parser/text.mjs';
import '../css/parser/export.mjs';
import '../css/parser/tree.mjs';
import '../svg/parse.mjs';
import './attribs.mjs';
import '../svg/data/attributes.mjs';
import '../svg/analyse.mjs';
import '../svg/analyse/error.mjs';

function checkPalette(palette, expectMonotone) {
  palette.colors.forEach((color) => {
    if (typeof color === "string") {
      throw new Error("Unexpected color: " + color);
    }
    switch (color.type) {
      case "none":
      case "transparent":
        return;
      case "current":
        if (!expectMonotone) {
          throw new Error(
            "Unexpected color: " + colorToString(color)
          );
        }
        return;
      case "rgb":
      case "hsl":
        if (expectMonotone) {
          throw new Error(
            "Unexpected color: " + colorToString(color)
          );
        }
        return;
      default:
        if (color.type !== "function" || color.func !== "url") {
          throw new Error(
            "Unexpected color: " + colorToString(color)
          );
        }
    }
  });
}
async function validateColors(svg, expectMonotone, options) {
  const palette = await parseColors(svg, options);
  checkPalette(palette, expectMonotone);
  return palette;
}
function validateColorsSync(svg, expectMonotone, options) {
  const palette = parseColorsSync(svg, options);
  checkPalette(palette, expectMonotone);
  return palette;
}

export { validateColors, validateColorsSync };
