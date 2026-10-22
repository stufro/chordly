import { Controller } from "@hotwired/stimulus"

// Opens a Bulma modal by id and closes whichever is open
export default class extends Controller {
  static targets = ["modal"]

  open({ params: { id } }) {
    this.modalTargets.find((modal) => modal.id === id).classList.add("is-active")
  }

  close() {
    this.modalTargets.forEach((modal) => modal.classList.remove("is-active"))
  }
}
