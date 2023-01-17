import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  stopPropagation(event) {
    event.stopPropagation()
  }
}
