import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "guitarChords", "ukuleleChords", "selectBox"]

  show(event) {
    const selected = event.target.id;
    const toShow = this.targets.findTarget(`${selected}Chords`)

    toShow.style.display = "block"
    this.selectBoxTarget.style.display = "none"
    this.iconTarget.classList = ["svg-primary"]
  }

  click_icon() {
    this.iconTarget.classList = ["svg-disabled"]
    this.selectBoxTarget.style.display = "block"
    this.guitarChordsTarget.style.display = "none"
    this.ukuleleChordsTarget.style.display = "none"
  }
}
