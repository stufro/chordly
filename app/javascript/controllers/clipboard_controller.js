import Clipboard from '@stimulus-components/clipboard'

export default class extends Clipboard {
  // The button is turbo-permanent, so Turbo can move it in after the controller connects
  buttonTargetConnected(button) {
    this.originalText = button.innerHTML
  }

  copy(event) {
    super.copy(event)

    navigator.clipboard.writeText(this.sourceTarget.innerText).then(() => this.copied())
  }

  copied() {
    super.copied()

    this.buttonTarget.innerHTML = this.data.get('successContent')

    this.timeout = setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalText
    }, this.successDurationValue)
  }
}

