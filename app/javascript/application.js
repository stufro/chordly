// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import '@fortawesome/fontawesome-free/js/fontawesome.js'
import '@fortawesome/fontawesome-free/js/solid.js'
import '@fortawesome/fontawesome-free/js/regular.js'
import '@fortawesome/fontawesome-free/js/brands.js'
import "trix"
import "@rails/actiontext"
import LocalTime from "local-time"

LocalTime.start()

function loadAdsense() {
  document.querySelectorAll("ins.adsbygoogle").forEach(() => {
    try {
      (adsbygoogle = window.adsbygoogle || []).push({})
      console.log("Adsense done")
    } catch (e) {
      console.log("Adsense error:", e)
    }
  })
}

document.addEventListener("DOMContentLoaded", loadAdsense)
document.addEventListener("turbo:render", loadAdsense)

