'use strict';

const css_parse = require('../css/parse.cjs');
const css_parser_export = require('../css/parser/export.cjs');
const css_parser_tokens = require('../css/parser/tokens.cjs');
const css_parser_tree = require('../css/parser/tree.cjs');
const svg_parse = require('./parse.cjs');
require('../css/parser/error.cjs');
require('../css/parser/strings.cjs');
require('../css/parser/text.cjs');

function parseItem(item, callback, done) {
  const tagName = item.tagName;
  const $element = item.$element;
  function parseStyleItem(done2) {
    const content = $element.text();
    if (typeof content !== "string") {
      $element.remove();
      return done2();
    }
    const tokens = css_parser_tokens.getTokens(content);
    if (!(tokens instanceof Array)) {
      throw new Error("Error parsing style");
    }
    let changed2 = false;
    const selectorStart = [];
    let newTokens = [];
    const parsedTokens = () => {
      if (changed2) {
        const tree = css_parser_tree.tokensTree(
          newTokens.filter((token) => token !== null)
        );
        if (!tree.length) {
          $element.remove();
        } else {
          const newContent = css_parser_export.tokensToString(tree);
          item.$element.text("\n" + newContent);
        }
      }
      done2();
    };
    const nextToken = () => {
      const token = tokens.shift();
      if (token === void 0) {
        return parsedTokens();
      }
      switch (token.type) {
        case "selector":
          selectorStart.push(newTokens.length);
          newTokens.push(token);
          return nextToken();
        case "close":
          selectorStart.pop();
          newTokens.push(token);
          return nextToken();
        case "at-rule": {
          selectorStart.push(newTokens.length);
          const prop = token.rule;
          const value = token.value;
          const isAnimation = prop === "keyframes" || prop.slice(0, 1) === "-" && prop.split("-").pop() === "keyframes";
          const childTokens = [];
          const animationRules = /* @__PURE__ */ Object.create(null);
          let depth = 1;
          let index = 0;
          let isFrom = false;
          while (depth > 0) {
            const childToken = tokens[index];
            index++;
            if (!childToken) {
              throw new Error("Something went wrong parsing CSS");
            }
            childTokens.push(childToken);
            switch (childToken.type) {
              case "close": {
                depth--;
                isFrom = false;
                break;
              }
              case "selector": {
                depth++;
                if (isAnimation) {
                  const rule = childToken.code;
                  if (rule === "from" || rule === "0%") {
                    isFrom = true;
                  }
                }
                break;
              }
              case "at-rule": {
                depth++;
                if (isAnimation) {
                  throw new Error(
                    "Nested at-rule in keyframes ???"
                  );
                }
                break;
              }
              case "rule": {
                if (isAnimation && isFrom) {
                  animationRules[childToken.prop] = childToken.value;
                }
                break;
              }
            }
          }
          const skipCount = childTokens.length;
          callback(
            isAnimation ? {
              type: "keyframes",
              prop,
              value,
              token,
              childTokens,
              from: animationRules,
              prevTokens: newTokens,
              nextTokens: tokens.slice(0)
            } : {
              type: "at-rule",
              prop,
              value,
              token,
              childTokens,
              prevTokens: newTokens,
              nextTokens: tokens.slice(0)
            },
            (result) => {
              if (result !== void 0) {
                if (isAnimation) {
                  if (result !== value) {
                    changed2 = true;
                    token.value = result;
                  }
                  newTokens.push(token);
                  for (let i = 0; i < skipCount; i++) {
                    tokens.shift();
                  }
                  newTokens = newTokens.concat(childTokens);
                } else {
                  if (result !== value) {
                    throw new Error(
                      "Changing value for at-rule is not supported"
                    );
                  }
                  newTokens.push(token);
                }
              } else {
                changed2 = true;
                for (let i = 0; i < skipCount; i++) {
                  tokens.shift();
                }
              }
              nextToken();
            }
          );
          return;
        }
        case "rule": {
          const value = token.value;
          const selectorTokens = selectorStart.map((index) => newTokens[index]).filter((item2) => item2 !== null);
          callback(
            {
              type: "global",
              prop: token.prop,
              value,
              token,
              selectorTokens,
              selectors: selectorTokens.reduce(
                (prev, current) => {
                  switch (current.type) {
                    case "selector": {
                      return prev.concat(
                        current.selectors
                      );
                    }
                  }
                  return prev;
                },
                []
              ),
              prevTokens: newTokens,
              nextTokens: tokens.slice(0)
            },
            (result) => {
              if (result !== void 0) {
                if (result !== value) {
                  changed2 = true;
                  token.value = result;
                }
                newTokens.push(token);
              } else {
                changed2 = true;
              }
              nextToken();
            }
          );
          return;
        }
      }
    };
    nextToken();
  }
  if (tagName === "style") {
    return parseStyleItem(done);
  }
  const attribs = item.element.attribs;
  if (attribs.style === void 0) {
    return done();
  }
  const parsedStyle = css_parse.parseInlineStyle(attribs.style);
  if (parsedStyle === null) {
    $element.removeAttr("style");
    return done();
  }
  const propsQueue = Object.keys(parsedStyle);
  let changed = false;
  const parsedProps = () => {
    if (changed) {
      const newStyle = Object.keys(parsedStyle).map((key) => key + ":" + parsedStyle[key] + ";").join("");
      if (!newStyle.length) {
        $element.removeAttr("style");
      } else {
        $element.attr("style", newStyle);
      }
    }
    done();
  };
  const nextProp = () => {
    const prop = propsQueue.shift();
    if (prop === void 0) {
      return parsedProps();
    }
    const value = parsedStyle[prop];
    callback(
      {
        type: "inline",
        prop,
        value,
        item
      },
      (result) => {
        if (result !== value) {
          changed = true;
          if (result === void 0) {
            delete parsedStyle[prop];
          } else {
            parsedStyle[prop] = result;
          }
        }
        nextProp();
      }
    );
  };
  nextProp();
}
async function parseSVGStyle(svg, callback) {
  return svg_parse.parseSVG(svg, (item) => {
    return new Promise((fulfill, reject) => {
      try {
        parseItem(
          item,
          (styleItem, done) => {
            try {
              const result = callback(styleItem);
              if (result instanceof Promise) {
                result.then(done).catch(reject);
              } else {
                done(result);
              }
            } catch (err) {
              reject(err);
            }
          },
          fulfill
        );
      } catch (err) {
        reject(err);
      }
    });
  });
}
function parseSVGStyleSync(svg, callback) {
  let isSync = true;
  svg_parse.parseSVGSync(svg, (item) => {
    parseItem(
      item,
      (styleItem, done) => {
        done(callback(styleItem));
      },
      () => {
        if (!isSync) {
          throw new Error("parseSVGStyleSync callback was async");
        }
      }
    );
  });
  isSync = false;
}

exports.parseSVGStyle = parseSVGStyle;
exports.parseSVGStyleSync = parseSVGStyleSync;
