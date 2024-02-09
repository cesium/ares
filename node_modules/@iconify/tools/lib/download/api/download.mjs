import { promisify } from 'util';
import { pipeline } from 'stream';
import { writeFile } from 'fs/promises';

promisify(pipeline);
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
  await writeFile(target, Buffer.from(data));
}

export { downloadFile };
