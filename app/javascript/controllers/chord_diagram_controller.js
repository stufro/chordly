import { Controller } from "@hotwired/stimulus"
import ChordJS from "../chords"

export default class extends Controller {
  connect() {
    console.log("Gfds")
    ChordJS.replace()
  }
}
