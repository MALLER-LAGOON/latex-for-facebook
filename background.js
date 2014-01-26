/*
 * Load CDN stored mathjax from Facebook.com
 */
chrome.webRequest.onHeadersReceived.addListener(function(details) {
  var i = 0
  while (i < details.responseHeaders.length) {
    if (details.responseHeaders[i].name.toUpperCase() === "CONTENT-SECURITY-POLICY") {
      details.responseHeaders[i].value = details.responseHeaders[i].value.replace("script-src", "script-src https://c328740.ssl.cf1.rackcdn.com")
    }
    i++
  }
  return {
    responseHeaders: details.responseHeaders
  }
}, {
  urls: ["*://*.facebook.com/*"],
  types: ["main_frame", "sub_frame", "stylesheet", "script", "image", "object", "xmlhttprequest", "other"]
}, ["blocking", "responseHeaders"])
