# frozen_string_literal: true

require "term/ansicolor"

class RakeAnnouncer
  # rubocop:disable-next Rails/Output
  def self.log_step(message)
    puts "\n#{Term::ANSIColor.magenta}#{Term::ANSIColor.underline}● #{message}#{Term::ANSIColor.reset}"
  end
end
