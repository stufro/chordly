import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row"]

  navigate(event) {
    const row = event.currentTarget
    const href = row.dataset.href
    if (href) {
      window.location.href = href
    }
  }
}
