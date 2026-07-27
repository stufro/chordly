Rails.application.config.middleware.use ExceptionNotification::Rack,
                                        email: {
                                          email_prefix: "[Chordly Error] ",
                                          sender_address: %("Chordly Errors" <errors@chordly.co.uk>),
                                          exception_recipients: %w[support@chordly.co.uk]
                                        }
