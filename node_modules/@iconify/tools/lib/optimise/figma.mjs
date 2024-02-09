import { defsTag, maskTags, symbolTag } from '../svg/data/tags.mjs';

function isTinyNumber(value, limit) {
  const num = parseInt(value);
  return !isNaN(num) && Math.abs(num) < limit;
}
function checkClipPathNode(clipNode, expectedWidth, expectedHeight) {
  for (const attr in clipNode.attribs) {
    if (attr !== "id") {
      return false;
    }
  }
  const children = clipNode.children.filter((node) => node.type !== "text");
  if (children.length !== 1) {
    return false;
  }
  const childNode = children[0];
  if (childNode.type !== "tag" || childNode.children.length) {
    return false;
  }
  const attribs = {
    ...childNode.attribs
  };
  delete attribs["fill"];
  const fill = (childNode.attribs["fill"] ?? "").toLowerCase();
  if (fill !== "white" && fill !== "#fff" && fill !== "#ffffff") {
    console.warn(
      "Unxepected fill on clip path:",
      childNode.attribs["fill"]
    );
    return false;
  }
  switch (childNode.tagName) {
    case "rect": {
      const width = parseInt(childNode.attribs["width"]);
      const height = parseInt(childNode.attribs["height"]);
      if (width !== expectedWidth || height !== expectedHeight) {
        console.warn("Invalid size of clip path");
        return false;
      }
      delete attribs["width"];
      delete attribs["height"];
      break;
    }
    default:
      console.warn(
        "Unexpected tag in Figma clip path:",
        childNode.tagName
      );
      return false;
  }
  Object.keys(attribs).forEach((attr) => {
    const value = attribs[attr];
    switch (attr) {
      case "transform": {
        const translateStart = "translate(";
        const translateEnd = ")";
        if (value.startsWith(translateStart) && value.endsWith(translateEnd)) {
          const translateParts = value.slice(translateStart.length, 0 - translateEnd.length).split(/\s+/);
          const limit = Math.min(expectedWidth, expectedHeight) / 1e3;
          if (translateParts.length === 2 && isTinyNumber(translateParts[0], limit) && isTinyNumber(translateParts[1], limit)) {
            delete attribs[attr];
          }
        }
      }
    }
  });
  return {
    node: clipNode,
    attribs
  };
}
const urlStart = "url(#";
const urlEnd = ")";
function removeFigmaClipPathFromSVG(svg) {
  const cheerio = svg.$svg;
  const $root = svg.$svg(":root");
  const children = $root.children();
  const backup = svg.toString();
  const shapesToClip = [];
  let clipID;
  for (let i = 0; i < children.length; i++) {
    const node = children[i];
    if (node.type === "tag") {
      const tagName = node.tagName;
      if (!defsTag.has(tagName) && !maskTags.has(tagName) && !symbolTag.has(tagName)) {
        const clipPath2 = node.attribs["clip-path"];
        if (!clipPath2 || !clipPath2.startsWith(urlStart) || !clipPath2.endsWith(urlEnd)) {
          return false;
        }
        const id = clipPath2.slice(urlStart.length, 0 - urlEnd.length);
        if (typeof clipID === "string" && clipID !== id) {
          return false;
        }
        clipID = id;
        shapesToClip.push(node);
      }
    }
  }
  if (typeof clipID !== "string") {
    return false;
  }
  const checkClipPath = (node) => {
    const id = node.attribs["id"];
    if (id !== clipID) {
      return;
    }
    const result = checkClipPathNode(
      node,
      svg.viewBox.width,
      svg.viewBox.height
    );
    cheerio(node).remove();
    return result;
  };
  const findClipPath = () => {
    for (let i = 0; i < children.length; i++) {
      const node = children[i];
      if (node.type === "tag") {
        const tagName = node.tagName;
        if (defsTag.has(tagName)) {
          const defsChildren = node.children;
          for (let j = 0; j < defsChildren.length; j++) {
            const childNode = defsChildren[j];
            if (childNode.type === "tag" && childNode.tagName === "clipPath") {
              const result = checkClipPath(childNode);
              if (result !== void 0) {
                const validChildren = node.children.filter(
                  (test) => {
                    if (test.type === "text") {
                      return false;
                    }
                    return true;
                  }
                );
                if (!validChildren.length) {
                  cheerio(node).remove();
                }
                return result;
              }
            }
          }
        }
        if (tagName === "clipPath") {
          const result = checkClipPath(node);
          if (result !== void 0) {
            return result;
          }
        }
      }
    }
  };
  const clipPath = findClipPath();
  if (!clipPath) {
    svg.load(backup);
    return false;
  }
  const attribs = clipPath.attribs;
  for (let i = 0; i < shapesToClip.length; i++) {
    const node = shapesToClip[i];
    cheerio(node).removeAttr("clip-path");
    for (const attr in attribs) {
      if (node.attribs[attr] !== void 0) {
        svg.load(backup);
        return false;
      }
      cheerio(node).attr(attr, attribs[attr]);
    }
  }
  return true;
}

export { removeFigmaClipPathFromSVG };
