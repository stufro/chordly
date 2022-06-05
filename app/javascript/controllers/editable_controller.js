import { Controller } from "@hotwired/stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = { field: String, url: String }

  connect() {
    this.element.setAttribute("contenteditable", "true")
    this.element.addEventListener("blur", () => { this.save() })
    this.originalValue = this.element.textContent
  }

  save() {
    if(this.element.textContent === this.originalValue) return 

    let formData = new FormData()
    formData.append(`chord_sheet[${this.fieldValue}]`, this.buildValue());

    patch(this.urlValue, {
      body: formData,
      responseKind: "turbo-stream"
    }).then(() => {
      this.originalValue = this.element.textContent
    })
   }

  buildValue() {
    if(this.fieldValue == "content") {
      let lines = Array.from(this.element.querySelectorAll("span"))
      let transformedLines = lines.map(line => {
        return `${line.textContent}\r`
      })
      return transformedLines.join("")
    } else {
      return this.element.textContent
    }
  }
}