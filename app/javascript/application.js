// Analytics page-view tracking on Turbo navigation events.
// This handler runs on every turbo:load so that SPA-like navigation
// (Turbo Drive) is captured without a full page reload.
// The initial page load is also captured by turbo:load firing on first render.
document.addEventListener("turbo:load", function () {
  var key = window.trackingKey;
  var endpoint = window.trackingEndpoint;
  if (!key || !endpoint) return;

  var page = window.location.pathname;
  var ref = document.referrer || "";

  if (typeof fetch !== "undefined") {
    fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ key: key, event: "page_view", path: page, referrer: ref })
    }).catch(function () {
      // Network failures are benign — do not surface to the user.
    });
  }
});