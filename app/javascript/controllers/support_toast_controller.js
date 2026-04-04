import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

export default class extends Controller {
  connect() {
    patch("/users/support_toast", {
      body: JSON.stringify({ action_type: "show" })
    })
  }

  dismiss(event) {
    const href = event.currentTarget.href
    patch("/users/support_toast", {
      body: JSON.stringify({ action_type: "dismiss" })
    }).then(() => {
      this.element.remove()
      if (href) window.location.href = href
    }).catch(() => this.element.remove())
  }

  trackClick() {
    patch("/users/support_toast", {
      body: JSON.stringify({ action_type: "click" })
    })
    // No preventDefault — let the external link open normally
  }
}
