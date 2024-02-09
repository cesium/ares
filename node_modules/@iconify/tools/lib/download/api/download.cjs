'use strict';

const util = require('util');
const stream = require('stream');
const promises = require('fs/promises');

util.promisify(stream.pipeline);
async function downloadFile(query, target) {
  const params = query.params ? query.params.toString() : "";
  const url = query.uri + (params ? "?" + params : "");
  const headers = query.headers;
  const response = await fetch(url, {
    headers
  });
  if (!response.ok || !response.body) {
    throw new Error(`Error downloading ${url}: ${response.status}`);
  }
  const data = await response.arrayBuffer();
  await promises.writeFile(target, Buffer.from(data));
}

exports.downloadFile = downloadFile;
