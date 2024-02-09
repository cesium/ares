function parse(svg, callback, done) {
  function checkNode(element, parents, done2) {
    if (element.type !== "tag") {
      return done2();
    }
    const $element = cheerio(element);
    const tagName = element.tagName;
    const item = {
      tagName,
      element,
      $element,
      svg,
      parents,
      testChildren: true,
      removeNode: false
    };
    callback(item, () => {
      const newParents = parents.slice(0);
      newParents.unshift(item);
      let queue = [];
      if (tagName !== "style" && item.testChildren && !item.removeNode) {
        const children = $element.children().toArray();
        queue = children.slice(0);
      }
      const next = () => {
        const queueItem = queue.shift();
        if (!queueItem) {
          if (item.removeNode) {
            $element.remove();
          }
          return done2();
        }
        checkNode(queueItem, newParents, next);
      };
      next();
    });
  }
  const cheerio = svg.$svg;
  const $root = svg.$svg(":root");
  checkNode($root.get(0), [], done);
}
function parseSVG(svg, callback) {
  return new Promise((fulfill, reject) => {
    parse(
      svg,
      (item, next) => {
        const result = callback(item);
        if (result instanceof Promise) {
          result.then(next).catch(reject);
        } else {
          next();
        }
      },
      fulfill
    );
  });
}
function parseSVGSync(svg, callback) {
  let isSync = true;
  parse(
    svg,
    (item, next) => {
      callback(item);
      next();
    },
    () => {
      if (!isSync) {
        throw new Error("parseSVGSync callback was async");
      }
    }
  );
  isSync = false;
}

export { parseSVG, parseSVGSync };
