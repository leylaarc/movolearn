(function () {
  // Paste the live App Store URL from App Store Connect when the listing is public.
  // Example: "https://apps.apple.com/app/id1234567890"
  var APP_STORE_URL = "https://apps.apple.com/app/movo-learn";

  document.querySelectorAll("[data-app-store]").forEach(function (link) {
    link.setAttribute("href", APP_STORE_URL);
  });
})();
