'use strict';

const download_api_cache = require('./cache.cjs');
require('fs');
require('crypto');
require('../../misc/scan.cjs');

async function sendAPIQuery(query, cache) {
  const cacheKey = cache ? download_api_cache.apiCacheKey(query) : "";
  if (cache) {
    const cached = await download_api_cache.getAPICache(cache.dir, cacheKey);
    if (cached) {
      return cached;
    }
  }
  const result = await sendQuery(query);
  if (cache && typeof result !== "number") {
    try {
      await download_api_cache.storeAPICache(cache, cacheKey, result);
    } catch (err) {
      console.error("Error writing API cache");
    }
  }
  return result;
}
async function sendQuery(query) {
  const params = query.params ? query.params.toString() : "";
  const url = query.uri + (params ? "?" + params : "");
  console.log("Fetch:", url);
  const headers = query.headers;
  try {
    const response = await fetch(url, {
      headers
    });
    if (response.status >= 400) {
      return response.status;
    }
    return await response.text();
  } catch (err) {
    return 404;
  }
}

exports.sendAPIQuery = sendAPIQuery;
