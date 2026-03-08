// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"


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

// Redirect to maintenance page on 503 responses
document.addEventListener("turbo:frame-missing", (event) => {
  if (event.detail.response.status === 503) {
    event.preventDefault()
    window.location.href = event.detail.response.url
  }
})

document.addEventListener("DOMContentLoaded", loadAdsense)
document.addEventListener("turbo:render", loadAdsense)

