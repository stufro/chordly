import { Application } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application
window.Turbo = Turbo

import Clipboard from '@stimulus-components/clipboard'
application.register('clipboard', Clipboard)

import TextareaAutogrow from 'stimulus-textarea-autogrow'
application.register('textarea-autogrow', TextareaAutogrow)

export { application }
