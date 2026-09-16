import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { filename: String }

  async download(event) {
    event.preventDefault()
    if (this.buttonTarget.disabled) return

    this.buttonTarget.disabled = true
    this.buttonTarget.classList.add("is-loading")

    try {
      const response = await fetch(this.element.action, {
        headers: { Accept: "application/pdf" }
      })
      if (!response.ok) throw new Error(`PDF download failed with status ${response.status}`)

      const url = URL.createObjectURL(await response.blob())
      const link = document.createElement("a")
      link.href = url
      link.download = this.filenameValue
      document.body.appendChild(link)
      link.click()
      link.remove()
      setTimeout(() => URL.revokeObjectURL(url))
    } finally {
      this.buttonTarget.disabled = false
      this.buttonTarget.classList.remove("is-loading")
    }
  }
}
