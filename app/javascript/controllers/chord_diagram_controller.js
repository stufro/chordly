import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "guitarChords", "ukuleleChords", "wrapper"]

  connect() {
    this.show()
  }

  closeOnClickOutside(event) {
    if (this.wrapperTarget.contains(event.target)) return
    this.close()
  }

  set(event) {
    localStorage.setItem("chord-diagrams", event.target.id)
    this.close()
    this.show()
  }

  click_icon() {
    localStorage.removeItem("chord-diagrams")
    this.wrapperTarget.classList.toggle("is-active")
    this.buttonTarget.setAttribute("aria-expanded", this.wrapperTarget.classList.contains("is-active"))
    this.show()
  }

  close() {
    this.wrapperTarget.classList.remove("is-active")
    this.buttonTarget.setAttribute("aria-expanded", false)
  }

  show() {
    const selected = localStorage.getItem("chord-diagrams");

    if (!selected) {
      this.buttonTarget.classList.add("is-outlined")
      this.guitarChordsTarget.classList.add("hidden")
      this.ukuleleChordsTarget.classList.add("hidden")
    } else {
      const toShow = this.targets.findTarget(`${selected}Chords`)

      toShow.classList.remove("hidden")
      this.buttonTarget.classList.remove("is-outlined")
    }
  }
}
