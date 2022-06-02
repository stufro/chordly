# frozen_string_literal: true

class ChordSheet < ApplicationRecord
  def transpose(direction)
    content.map! do |line_hash|
      line = SheetLine.new(line_hash)
      next(line) unless line.chords?

      line.transpose(direction)
    end
    self
  end
end
