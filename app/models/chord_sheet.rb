class ChordSheet < ApplicationRecord
  def transpose(direction)
    content.map! do |line_hash|
      line = SheetLine.new(line_hash)
      next(line) unless line.chords?

      {"content" => line.transpose(direction), "type" => "chords"}
    end
  end
end