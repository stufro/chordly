import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

export default class extends Controller {
  static targets = [ "icon" ]
  static values = {
    mode: String
  }

  switch() {
    this.iconTarget.classList.toggle("fa-moon")
    this.iconTarget.classList.toggle("fa-sun")

    document.documentElement.classList.toggle("theme-dark")
    document.documentElement.classList.toggle("theme-light")

    this.modeValue = this.modeValue === "dark" ? "light" : "dark"
    this.updateThemeOnServer(this.modeValue)
  }

  updateThemeOnServer(mode) {
    patch("/users/theme", {
      body: JSON.stringify({ theme: mode })
    })
      .then(response => {
        if (response.ok) {
          console.debug("Theme updated")
        } else {
          console.error("Failed to update theme:", response.status)
        }
      })
      .catch(error => {
        console.error("Network error:", error)
      })
  }
}
