const host_url = import.meta.env.HOST_URL;
const blocked_urls = import.meta.env.BLOCKED_URLS.split(",");

export function onRequest({ locals, request }, next) {
  for (const blockedPath of blocked_urls) {
    let path = host_url + blockedPath;
    if (normalizePath(request.url) === path) {
      return Response.redirect(`${host_url}/404`, 302);
    }
  }

  return next();
}

// Utility function to remove trailing slash
function normalizePath(path) {
  // This removes the trailing slash if it exists
  return path.endsWith("/") ? path.slice(0, -1) : path;
}
