import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "searchable"]

  search() {
    this.searchableTargets.forEach(element => {
      const elementTitle = element.querySelector(".title").innerText.toLowerCase()
      if (!elementTitle.includes(this.inputTarget.value.toLowerCase())) {
        element.classList.add("is-hidden")
      } else {
        element.classList.remove("is-hidden")
      }
    });
  }
}