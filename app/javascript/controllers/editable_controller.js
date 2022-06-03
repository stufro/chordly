import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { field: String, url: String }

  connect() {
    this.element.setAttribute("contenteditable", "true")
    this.element.addEventListener("blur", () => { this.save() })
  }

  save() {
    let formData = new FormData()
    formData.append(`chord_sheet[${this.fieldValue}]`, this.element.textContent);

    fetch(this.urlValue, {
      body: formData,
      method: 'PATCH',
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
    })
  }
}