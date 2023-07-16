import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "guitarChords", "ukuleleChords", "selectBox"]

  connect() {
    this.show()
    document.addEventListener("turbo:frame-render", () => this.show())
  }

  set(event) {
    localStorage.setItem("chord-diagrams", event.target.id)
    this.selectBoxTarget.classList.add("hidden")
    this.show()
  }

  click_icon() {
    if (localStorage.getItem("chord-diagrams")) {
      localStorage.removeItem("chord-diagrams")
    } else {
      this.selectBoxTarget.classList.toggle("hidden")
    }
    this.show()
  }

  show() {
    const selected = localStorage.getItem("chord-diagrams");

    if (!selected) {
      this.iconTarget.classList = ["svg-disabled"]
      this.guitarChordsTarget.classList.add("hidden")
      this.ukuleleChordsTarget.classList.add("hidden")
    } else {
      const toShow = this.targets.findTarget(`${selected}Chords`)

      toShow.classList.remove("hidden")
      this.iconTarget.classList = ["svg-primary"]
    }
  }
}
