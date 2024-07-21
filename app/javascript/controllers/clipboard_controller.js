import Clipboard from '@stimulus-components/clipboard'

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

    this.buttonTarget.innerHTML = this.data.get('successContent')

    this.timeout = setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalText
    }, this.successDurationValue)
  }
}

