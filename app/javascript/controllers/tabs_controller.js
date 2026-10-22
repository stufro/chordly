import { Controller } from "@hotwired/stimulus"

// Shows the panel at the same position as the selected tab
export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    event.preventDefault()
    const index = this.tabTargets.findIndex((tab) => tab.contains(event.currentTarget))

    this.tabTargets.forEach((tab, tabIndex) => tab.classList.toggle("is-active", tabIndex === index))
    this.panelTargets.forEach((panel, panelIndex) => panel.classList.toggle("is-hidden", panelIndex !== index))
  }
}
