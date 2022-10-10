import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"];

  connect() {
    if(localStorage.getItem("accepted-cookies") == "true") {
      this.element.parentNode.removeChild(this.element)
    }
  }

  accept() {
    this.element.parentNode.removeChild(this.element)
    localStorage.setItem("accepted-cookies", "true")
  }
}