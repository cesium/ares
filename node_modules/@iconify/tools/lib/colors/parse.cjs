'use strict';

const colors = require('@iconify/utils/lib/colors');
const svg_data_tags = require('../svg/data/tags.cjs');
const svg_parseStyle = require('../svg/parse-style.cjs');
const colors_attribs = require('./attribs.cjs');
const svg_data_attributes = require('../svg/data/attributes.cjs');
const svg_analyse = require('../svg/analyse.cjs');
require('../css/parse.cjs');
require('../css/parser/tokens.cjs');
require('../css/parser/error.cjs');
require('../css/parser/strings.cjs');
require('../css/parser/text.cjs');
require('../css/parser/export.cjs');
require('../css/parser/tree.cjs');
require('../svg/parse.cjs');
require('../svg/analyse/error.cjs');

const propsToCheck = Object.keys(colors_attribs.defaultColorValues);
const animatePropsToCheck = ["from", "to", "values"];
function createContext(options, callback) {
  const result = {
    colors: [],
    hasUnsetColor: false,
    hasGlobalStyle: false
  };
  const defaultColor = typeof options.defaultColor === "string" ? colors.stringToColor(options.defaultColor) : options.defaultColor;
  function findColor(color, add = false) {
    const isString = typeof color === "string";
    for (let i = 0; i < result.colors.length; i++) {
      const item = result.colors[i];
      if (item === color) {
        return item;
      }
      if (!isString && typeof item !== "string" && colors.compareColors(item, color)) {
        return item;
      }
    }
    if (add) {
      result.colors.push(color);
      return color;
    }
    return null;
  }
  function addColorToItem(prop, color, item, add = true) {
    const addedColor = findColor(color, add !== false);
    if (item) {
      const itemColors = item._colors || (item._colors = {});
      itemColors[prop] = addedColor === null ? color : addedColor;
    }
  }
  function getElementColor(prop, item, elements) {
    function find(prop2) {
      let currentItem = item;
      const allowDefaultColor = colors_attribs.allowDefaultColorValue[prop2];
      while (currentItem) {
        const element = elements.get(
          currentItem.index
        );
        const color = element._colors?.[prop2];
        if (color !== void 0) {
          return color;
        }
        if (allowDefaultColor) {
          if (allowDefaultColor === true || element.attribs[allowDefaultColor]) {
            return null;
          }
        }
        currentItem = currentItem.parent;
        if (currentItem?.usedAsMask) {
          return colors_attribs.defaultColorValues[prop2];
        }
      }
      return colors_attribs.defaultColorValues[prop2];
    }
    let propColor = find(prop);
    if (propColor !== null && typeof propColor === "object" && propColor.type === "current" && prop !== "color") {
      propColor = find("color");
    }
    return propColor;
  }
  function checkColor(done, prop, value, item) {
    switch (value.trim().toLowerCase()) {
      case "":
      case "inherit":
        return done();
    }
    const parsedColor = colors.stringToColor(value);
    const defaultValue = parsedColor || value;
    if (parsedColor?.type === "function" && parsedColor.func === "url") {
      addColorToItem(prop, defaultValue, item, false);
      return done(value);
    }
    if (!callback) {
      addColorToItem(prop, defaultValue, item);
      return done(value);
    }
    callback(
      [prop, value, parsedColor, item?.tagName, item],
      (callbackResult) => {
        switch (callbackResult) {
          case "remove": {
            return done(item ? callbackResult : void 0);
          }
          case "unset":
            return done();
        }
        if (callbackResult === value || parsedColor && callbackResult === parsedColor) {
          addColorToItem(prop, defaultValue, item);
          return done(value);
        }
        if (typeof callbackResult === "string") {
          const newColor = colors.stringToColor(callbackResult);
          addColorToItem(prop, newColor || callbackResult, item);
          return done(callbackResult);
        }
        const newValue = colors.colorToString(callbackResult);
        addColorToItem(prop, callbackResult, item);
        return done(newValue);
      }
    );
  }
  function parseStyleItem(item, done) {
    const prop = item.prop;
    const value = item.value;
    if (propsToCheck.indexOf(prop) === -1) {
      return done(value);
    }
    const attr = prop;
    checkColor(
      (newValue) => {
        if (newValue === void 0) {
          return done(newValue);
        }
        if (item.type === "global") {
          result.hasGlobalStyle = true;
        }
        return done(newValue);
      },
      attr,
      value
    );
  }
  return {
    result,
    defaultColor,
    rawOptions: options,
    findColor,
    addColorToItem,
    getElementColor,
    checkColor,
    parseStyleItem
  };
}
function analyseSVG(svg, context, done) {
  const iconData = svg_analyse.analyseSVGStructure(svg, context.rawOptions);
  const { elements, tree } = iconData;
  const cheerio = svg.$svg;
  const removedElements = /* @__PURE__ */ new Set();
  const parsedElements = /* @__PURE__ */ new Set();
  function removeElement(index, element) {
    function removeChildren(element2) {
      element2.children.forEach((item) => {
        if (item.type !== "tag") {
          return;
        }
        const element3 = item;
        const index2 = element3._index;
        if (index2 && !removedElements.has(index2)) {
          element3._removed = true;
          removedElements.add(index2);
          removeChildren(element3);
        }
      });
    }
    element._removed = true;
    removedElements.add(index);
    removeChildren(element);
    cheerio(element).remove();
  }
  function parseTreeItem(item, done2) {
    const index = item.index;
    if (removedElements.has(index) || parsedElements.has(index)) {
      return done2();
    }
    parsedElements.add(index);
    const element = elements.get(index);
    if (element._removed) {
      return done2();
    }
    const { tagName, attribs } = element;
    if (item.parent) {
      const parentIndex = item.parent.index;
      const parentElement = elements.get(
        parentIndex
      );
      if (parentElement._colors) {
        element._colors = {
          ...parentElement._colors
        };
      }
    }
    function parseCommonProps(done3) {
      const propsQueue = [];
      for (let i = 0; i < propsToCheck.length; i++) {
        const prop = propsToCheck[i];
        if (prop === "fill" && svg_data_tags.animateTags.has(tagName)) {
          continue;
        }
        const value = attribs[prop];
        if (value !== void 0) {
          propsQueue.push([prop, value]);
        }
      }
      const parsePropsQueue = () => {
        const queueItem = propsQueue.shift();
        if (!queueItem) {
          return done3();
        }
        const [prop, value] = queueItem;
        context.checkColor(
          (newValue) => {
            if (newValue !== value) {
              if (newValue === void 0) {
                cheerio(element).removeAttr(prop);
                if (element._colors) {
                  delete element._colors[prop];
                }
              } else if (newValue === "remove") {
                removeElement(index, element);
              } else {
                cheerio(element).attr(prop, newValue);
              }
            }
            return parsePropsQueue();
          },
          prop,
          value,
          element
        );
      };
      parsePropsQueue();
    }
    function checkAnimations(done3) {
      const propsQueue = [];
      if (svg_data_tags.animateTags.has(tagName)) {
        const attr = attribs.attributeName;
        if (propsToCheck.indexOf(attr) !== -1) {
          for (let i = 0; i < animatePropsToCheck.length; i++) {
            const elementProp = animatePropsToCheck[i];
            const fullValue = attribs[elementProp];
            if (typeof fullValue !== "string") {
              continue;
            }
            propsQueue.push([elementProp, fullValue]);
          }
        }
      }
      const parsePropsQueue = () => {
        const queueItem = propsQueue.shift();
        if (!queueItem) {
          return done3();
        }
        const [elementProp, fullValue] = queueItem;
        const splitValues = fullValue.split(";");
        let updatedValues = false;
        const parsedAllItems = () => {
          if (updatedValues) {
            cheerio(element).attr(
              elementProp,
              splitValues.join(";")
            );
          }
          return parsePropsQueue();
        };
        const parseItem = (index2) => {
          if (index2 >= splitValues.length) {
            return parsedAllItems();
          }
          const value = splitValues[index2];
          if (value === void 0) {
            return parseItem(index2 + 1);
          }
          context.checkColor(
            (newValue) => {
              if (newValue !== value) {
                updatedValues = true;
                splitValues[index2] = typeof newValue === "string" ? newValue : "";
              }
              parseItem(index2 + 1);
            },
            elementProp,
            value
            // Do not pass third parameter
          );
        };
        parseItem(0);
      };
      parsePropsQueue();
    }
    parseCommonProps(() => {
      checkAnimations(() => {
        if (!context.result.hasGlobalStyle) {
          let requiredProps;
          if (svg_data_tags.shapeTags.has(tagName)) {
            requiredProps = colors_attribs.shapeColorAttributes;
          }
          colors_attribs.specialColorAttributes.forEach((attr) => {
            if (svg_data_attributes.tagSpecificPresentationalAttributes[tagName]?.has(
              attr
            )) {
              requiredProps = [attr];
            }
          });
          if (requiredProps) {
            const itemColors = element._colors || (element._colors = {});
            for (let i = 0; i < requiredProps.length; i++) {
              const prop = requiredProps[i];
              const color = context.getElementColor(
                prop,
                item,
                elements
              );
              if (color === colors_attribs.defaultBlackColor) {
                const defaultColor = context.defaultColor;
                if (defaultColor) {
                  const defaultColorValue = typeof defaultColor === "function" ? defaultColor(
                    prop,
                    element,
                    item,
                    iconData
                  ) : defaultColor;
                  context.findColor(defaultColorValue, true);
                  cheerio(element).attr(
                    prop,
                    colors.colorToString(defaultColorValue)
                  );
                  itemColors[prop] = defaultColorValue;
                } else {
                  context.result.hasUnsetColor = true;
                }
              }
            }
          }
        }
        let index2 = 0;
        const parseChildItem = () => {
          if (index2 >= item.children.length) {
            return done2();
          }
          const childItem = item.children[index2];
          index2++;
          if (!childItem.usedAsMask) {
            parseTreeItem(childItem, parseChildItem);
          } else {
            parseChildItem();
          }
        };
        parseChildItem();
      });
    });
  }
  parseTreeItem(tree, done);
}
function parseColors(svg, options = {}) {
  const callback = options.callback;
  return new Promise((fulfill, reject) => {
    let context;
    try {
      context = createContext(
        options,
        callback ? (params, done) => {
          try {
            const result = callback(...params);
            if (result instanceof Promise) {
              result.then(done).catch(reject);
            } else {
              done(result);
            }
          } catch (err) {
            reject(err);
          }
        } : void 0
      );
    } catch (err) {
      reject(err);
      return;
    }
    svg_parseStyle.parseSVGStyle(svg, (item) => {
      return new Promise((fulfill2, reject2) => {
        try {
          context.parseStyleItem(item, fulfill2);
        } catch (err) {
          reject2(err);
        }
      });
    }).then(() => {
      try {
        analyseSVG(svg, context, () => {
          fulfill(context.result);
        });
      } catch (err) {
        reject(err);
      }
    }).catch(reject);
  });
}
function parseColorsSync(svg, options = {}) {
  const callback = options.callback;
  const context = createContext(
    options,
    callback ? (params, done) => {
      done(callback(...params));
    } : void 0
  );
  svg_parseStyle.parseSVGStyleSync(svg, (item) => {
    let isSync2 = true;
    let result;
    context.parseStyleItem(item, (value) => {
      if (!isSync2) {
        throw new Error("parseStyleItem callback supposed to be sync");
      }
      result = value;
    });
    isSync2 = false;
    return result;
  });
  let isSync = true;
  analyseSVG(svg, context, () => {
    if (!isSync) {
      throw new Error("analyseSVG callback supposed to be sync");
    }
  });
  isSync = false;
  return context.result;
}
function isEmptyColor(color) {
  const type = color.type;
  return type === "none" || type === "transparent";
}

exports.isEmptyColor = isEmptyColor;
exports.parseColors = parseColors;
exports.parseColorsSync = parseColorsSync;
