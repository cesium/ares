import { apiCacheKey, getAPICache, storeAPICache } from './cache.mjs';
import 'fs';
import 'crypto';
import '../../misc/scan.mjs';

async function sendAPIQuery(query, cache) {
  const cacheKey = cache ? apiCacheKey(query) : "";
  if (cache) {
    const cached = await getAPICache(cache.dir, cacheKey);
    if (cached) {
      return cached;
    }
  }
  const result = await sendQuery(query);
  if (cache && typeof result !== "number") {
    try {
      await storeAPICache(cache, cacheKey, result);
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

export { sendAPIQuery };
