import { Controller } from "@hotwired/stimulus"

// Shows a button's tooltip on long-press, as touch screens can't hover
export default class extends Controller {
  static targets = ["button"]

  buttonTargetConnected(button) {
    button.addEventListener("touchstart", this.press)
    button.addEventListener("touchmove", this.hide)
    button.addEventListener("touchend", this.release)
    button.addEventListener("touchcancel", this.release)
    button.addEventListener("contextmenu", this.preventMenu)
  }

  buttonTargetDisconnected(button) {
    button.removeEventListener("touchstart", this.press)
    button.removeEventListener("touchmove", this.hide)
    button.removeEventListener("touchend", this.release)
    button.removeEventListener("touchcancel", this.release)
    button.removeEventListener("contextmenu", this.preventMenu)
  }

  // Starts afresh in case the last press never got its touchend, e.g. a second finger or a frame re-render
  press = (event) => {
    const button = event.currentTarget
    clearTimeout(this.timeout)
    this.longPressed = false
    this.timeout = setTimeout(() => {
      this.longPressed = true
      button.classList.add("is-tooltip-visible")
    }, 500)
  }

  hide = (event) => {
    clearTimeout(this.timeout)
    event.currentTarget.classList.remove("is-tooltip-visible")
  }

  // Long-press opens the context menu, which takes the touch so touchend never arrives
  preventMenu = (event) => {
    event.preventDefault()
  }

  // Cancelling touchend stops the tap's click, so a long-press doesn't also press the button
  release = (event) => {
    this.hide(event)
    if (this.longPressed) event.preventDefault()
    this.longPressed = false
  }
}
