import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { patch } from '@rails/request.js'

export default class extends Controller {
  static targets = ["position"]
  static values = { url: String }

  connect() {
    Sortable.create(this.element, {
      sort: true,
      handle: ".handle",
      animation: 250,
      onEnd: this.onEnd.bind(this)
    })
  }

  onEnd(event) {
    this.updatePositionClientSide()

    const cards = event.to.querySelectorAll(".chord-sheet-card")
    const orderedIds = Array.from(cards).map(elem => elem.getAttribute("data-id"))

    let formData = new FormData()
    formData.append("new_order", orderedIds);

    patch(this.urlValue, {
      body: formData,
      responseKind: "turbo-stream"
    })
  }

  updatePositionClientSide() {
    this.positionTargets.forEach((element, index) => {
      element.innerText = index + 1;
    });
  }
}
