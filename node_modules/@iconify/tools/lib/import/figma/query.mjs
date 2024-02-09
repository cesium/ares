import { sendAPIQuery } from '../../download/api/index.mjs';
import { apiCacheKey, getAPICache, clearAPICache } from '../../download/api/cache.mjs';
import 'fs';
import 'crypto';
import '../../misc/scan.mjs';

function identicalDates(actual, expected) {
  if (typeof actual !== "string") {
    return false;
  }
  if (actual === expected) {
    return true;
  }
  return new Date(actual).toString() === new Date(expected).toString();
}
async function figmaFilesQuery(options, cache) {
  if (!options.token) {
    throw new Error("Missing Figma API token");
  }
  const params = new URLSearchParams();
  if (options.ids) {
    params.set("ids", options.ids.join(","));
  }
  if (options.version) {
    params.set("version", options.version);
  }
  if (options.depth) {
    params.set("depth", options.depth.toString());
  }
  const queryParams = {
    uri: "https://api.figma.com/v1/files/" + options.file,
    params,
    headers: {
      "X-FIGMA-TOKEN": options.token
    }
  };
  const isModified = async () => {
    if (!cache || !options.ifModifiedSince) {
      return true;
    }
    const cacheKey = apiCacheKey(queryParams);
    const cachedData = await getAPICache(cache.dir, cacheKey);
    if (!cachedData) {
      return true;
    }
    let ifModifiedSince;
    if (options.ifModifiedSince === true) {
      try {
        const parsedData2 = JSON.parse(cachedData);
        if (typeof parsedData2.lastModified !== "string") {
          await clearAPICache(cache.dir);
          return true;
        }
        ifModifiedSince = parsedData2.lastModified;
      } catch (err) {
        await clearAPICache(cache.dir);
        return true;
      }
    } else {
      ifModifiedSince = options.ifModifiedSince;
    }
    const versionCheckParams = {
      ...queryParams,
      params: new URLSearchParams(params)
    };
    versionCheckParams.params.set("depth", "1");
    const data2 = await sendAPIQuery(versionCheckParams);
    try {
      if (typeof data2 === "string") {
        const parsedData2 = JSON.parse(data2);
        if (identicalDates(parsedData2.lastModified, ifModifiedSince)) {
          return false;
        }
      }
    } catch (err) {
    }
    await clearAPICache(cache.dir);
    return true;
  };
  if (!await isModified()) {
    return "not_modified";
  }
  const data = await sendAPIQuery(queryParams, cache);
  if (typeof data === "number") {
    throw new Error(`Error retrieving document from API: ${data}`);
  }
  let parsedData;
  try {
    parsedData = JSON.parse(data);
  } catch (err) {
    throw new Error(`Error retrieving document from API: invalid data`);
  }
  if (typeof parsedData.status === "number") {
    const figmaError = parsedData;
    throw new Error(
      `Error retrieving document from API: ${figmaError.err}`
    );
  }
  const document = parsedData;
  if (document.editorType !== "figma") {
    throw new Error(
      `Error retrieving document from API: document is for ${document.editorType}`
    );
  }
  if (identicalDates(options.ifModifiedSince, document.lastModified)) {
    return "not_modified";
  }
  return document;
}
async function figmaImagesQuery(options, nodes, cache) {
  const uri = "https://api.figma.com/v1/images/" + options.file;
  const maxLength = 2048 - uri.length;
  const svgOptions = options.svgOptions || {};
  let ids = [];
  let idsLength = 0;
  let lastError;
  let found = 0;
  const query = async () => {
    const params = new URLSearchParams({
      ids: ids.join(","),
      format: "svg"
    });
    if (options.version) {
      params.set("version", options.version);
    }
    if (svgOptions.includeID) {
      params.set("svg_include_id", "true");
    }
    if (svgOptions.simplifyStroke) {
      params.set("svg_simplify_stroke", "true");
    }
    if (svgOptions.useAbsoluteBounds) {
      params.set("use_absolute_bounds", "true");
    }
    const data = await sendAPIQuery(
      {
        uri,
        params,
        headers: {
          "X-FIGMA-TOKEN": options.token
        }
      },
      cache
    );
    if (typeof data === "number") {
      lastError = data;
      return;
    }
    try {
      const parsedData = JSON.parse(data);
      const images = parsedData.images;
      for (const id in images) {
        const node = nodes.icons[id];
        const target = images[id];
        if (node && target) {
          node.url = target;
          found++;
        }
      }
    } catch (err) {
      return;
    }
  };
  const allKeys = Object.keys(nodes.icons);
  for (let i = 0; i < allKeys.length; i++) {
    const id = allKeys[i];
    ids.push(id);
    idsLength += id.length + 1;
    if (idsLength >= maxLength) {
      await query();
      ids = [];
      idsLength = 0;
    }
  }
  if (idsLength) {
    await query();
  }
  if (!found) {
    if (lastError) {
      throw new Error(
        `Error retrieving image data from API${lastError ? ": " + lastError.toString() : ""}`
      );
    } else {
      throw new Error("No valid icon layers were found");
    }
  }
  nodes.generatedIconsCount = found;
  return nodes;
}
async function figmaDownloadImages(nodes, cache) {
  const icons = nodes.icons;
  const ids = Object.keys(icons);
  let count = 0;
  let lastError;
  for (let i = 0; i < ids.length; i++) {
    const id = ids[i];
    const item = icons[id];
    if (!item.url) {
      continue;
    }
    const result = await sendAPIQuery(
      {
        uri: item.url
      },
      cache
    );
    if (typeof result === "number") {
      lastError = result;
      continue;
    }
    if (typeof result === "string") {
      count++;
      item.content = result;
    }
  }
  if (!count) {
    throw new Error(
      `Error retrieving images${lastError ? ": " + lastError.toString() : ""}`
    );
  }
  nodes.downloadedIconsCount = count;
  return nodes;
}

export { figmaDownloadImages, figmaFilesQuery, figmaImagesQuery };
