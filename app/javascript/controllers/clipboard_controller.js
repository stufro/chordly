import Clipboard from 'stimulus-clipboard'

export default class extends Clipboard {
  connect() {
    super.connect()

    this.originalText = this.buttonTarget.innerHTML
  }

  copy(event) {
    super.copy(event)

    navigator.clipboard.writeText(this.sourceTarget.innerText).then(() => this.copied())
  }

  copied() {
    super.copied()

    this.buttonTarget.disabled = true
    this.buttonTarget.innerHTML = this.data.get('successContent')

    this.timeout = setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalText
      this.buttonTarget.disabled = false
    }, this.successDurationValue)
  }
}