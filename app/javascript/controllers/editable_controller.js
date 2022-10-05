import { Controller } from "@hotwired/stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = { field: String, url: String }

  connect() {
    this.element.setAttribute("contenteditable", "true")
    this.element.addEventListener("blur", () => { this.save() })
    this.originalValue = this.element.innerText
  }

  save() {
    if(this.element.innerText === this.originalValue) return 

    let formData = new FormData()
    formData.append(`chord_sheet[${this.fieldValue}]`, this.element.innerText);

    patch(this.urlValue, {
      body: formData,
      responseKind: "turbo-stream"
    }).then(() => {
      this.originalValue = this.element.innerText
    })
   }
}