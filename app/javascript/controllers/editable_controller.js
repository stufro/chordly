import { Controller } from "@hotwired/stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = { field: String, url: String, model: String }

  connect() {
    this.element.setAttribute("contenteditable", "true")
    this.element.addEventListener("blur", () => { this.save() })
    this.originalValue = this.element.innerText
  }

  save() {
    if(this.element.innerText === this.originalValue) return

    let formData = new FormData()
    formData.append(`${this.modelValue}[${this.fieldValue}]`, this.element.innerText);

    patch(this.urlValue, {
      body: formData,
      responseKind: "turbo-stream"
    }).then(() => {
      this.originalValue = this.element.innerText
    })
   }
}
