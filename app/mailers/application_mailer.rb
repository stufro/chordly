class ApplicationMailer < ActionMailer::Base
  default from: "Chordly <no-reply@chordly.co.uk>", reply_to: "support@chordly.co.uk"
  layout "mailer"
end
