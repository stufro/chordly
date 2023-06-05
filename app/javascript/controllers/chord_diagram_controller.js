import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "guitarChords", "ukuleleChords", "selectBox"]

  show(event) {
    const selected = event.target.id;
    const toShow = this.targets.findTarget(`${selected}Chords`)

    toShow.classList.remove("hidden")
    this.selectBoxTarget.classList.add("hidden")
    this.iconTarget.classList = ["svg-primary"]
  }

  click_icon() {
    if(!this.guitarChordsTarget.classList.contains("hidden") || !this.ukuleleChordsTarget.classList.contains("hidden")) {
      this.guitarChordsTarget.classList.add("hidden")
      this.ukuleleChordsTarget.classList.add("hidden")
      this.iconTarget.classList = ["svg-disabled"]
    } else {
      this.selectBoxTarget.classList.toggle("hidden")
    }

  }
}
