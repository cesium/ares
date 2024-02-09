'use strict';

const colors = require('@iconify/utils/lib/colors');
const colors_parse = require('./parse.cjs');
require('../svg/data/tags.cjs');
require('../svg/parse-style.cjs');
require('../css/parse.cjs');
require('../css/parser/tokens.cjs');
require('../css/parser/error.cjs');
require('../css/parser/strings.cjs');
require('../css/parser/text.cjs');
require('../css/parser/export.cjs');
require('../css/parser/tree.cjs');
require('../svg/parse.cjs');
require('./attribs.cjs');
require('../svg/data/attributes.cjs');
require('../svg/analyse.cjs');
require('../svg/analyse/error.cjs');

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
            "Unexpected color: " + colors.colorToString(color)
          );
        }
        return;
      case "rgb":
      case "hsl":
        if (expectMonotone) {
          throw new Error(
            "Unexpected color: " + colors.colorToString(color)
          );
        }
        return;
      default:
        if (color.type !== "function" || color.func !== "url") {
          throw new Error(
            "Unexpected color: " + colors.colorToString(color)
          );
        }
    }
  });
}
async function validateColors(svg, expectMonotone, options) {
  const palette = await colors_parse.parseColors(svg, options);
  checkPalette(palette, expectMonotone);
  return palette;
}
function validateColorsSync(svg, expectMonotone, options) {
  const palette = colors_parse.parseColorsSync(svg, options);
  checkPalette(palette, expectMonotone);
  return palette;
}

exports.validateColors = validateColors;
exports.validateColorsSync = validateColorsSync;
