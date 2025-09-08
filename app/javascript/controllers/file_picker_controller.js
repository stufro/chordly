import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileName"]

  updateFileName(event) {
    const fileInput = event.target

    if (fileInput.files.length > 0) {
      this.fileNameTarget.textContent = fileInput.files[0].name
    }
  }
}
