import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "showMoreButton", "showFewerButton"]

  connect() {
    if(!this.isOverflown(this.containerTarget)) {
      this.showMoreButtonTarget.classList.add("is-hidden")
      this.containerTarget.classList.remove("see-more-container")
    }
  }

  toggle() {
    this.containerTarget.classList.toggle("see-more-container")

    this.showMoreButtonTarget.classList.toggle("is-hidden")
    this.showFewerButtonTarget.classList.toggle("is-hidden")
  }

  isOverflown(element) {
    return element.scrollHeight > element.clientHeight
  }
}