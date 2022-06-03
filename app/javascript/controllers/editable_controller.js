import { Controller } from "@hotwired/stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = { field: String, url: String }

  connect() {
    this.element.setAttribute("contenteditable", "true")
    this.element.addEventListener("blur", () => { this.save() })
  }

  save() {
    let formData = new FormData()
    formData.append(`chord_sheet[${this.fieldValue}]`, this.element.textContent);

    patch(this.urlValue, {
      body: formData,
      responseKind: "turbo-stream"
    })
   }
}