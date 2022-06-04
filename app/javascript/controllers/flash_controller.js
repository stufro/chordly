import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["closeButton"]

  connect() {
    this.closeButtonTarget.addEventListener("click", () => {
      this.element.parentNode.removeChild(this.element)
    })
  }
}