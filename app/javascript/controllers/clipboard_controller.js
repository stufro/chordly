import Clipboard from '@stimulus-components/clipboard'

export default class extends Clipboard {
  // The button is turbo-permanent, so Turbo can move it in after the controller connects
  buttonTargetConnected(button) {
    this.originalContent = button.innerHTML
  }

  // Copies the visible text rather than the base class's innerHTML
  copy(event) {
    event.preventDefault()

    navigator.clipboard.writeText(this.sourceTarget.innerText).then(() => this.copied())
  }
}
