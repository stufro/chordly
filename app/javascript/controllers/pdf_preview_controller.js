import { Controller } from "@hotwired/stimulus"

// Manages the PDF preview modal:
// - Auto-submits the form via standard Turbo form submission
// - Reloads the preview iframe after a successful turbo submit
// - Triggers a Turbo page refresh on close if any changes were saved
export default class extends Controller {
  static targets = ["form", "iframe"]

  connect() {
    this.hasChanges = false
  }

  autoSubmit() {
    this.hasChanges = true
    this.formTarget.requestSubmit()
  }

  reloadPreview(event) {
    if (event?.detail && !event.detail.success) return
    const iframe = this.iframeTarget
    // Re-assign src to force a fresh render (browsers cache same-src iframes)
    iframe.src = iframe.src
  }

  onClose() {
    if (!this.hasChanges) return
    this.hasChanges = false
    // Replace the current history entry so the main page reflects any saved style changes
    Turbo.visit(location, { action: "replace" })
  }

  // Also catch Escape (the frame-level keydown.esc->modal#close bypasses onClose)
  handleEsc(event) {
    if (event.key === "Escape") this.onClose()
  }
}

