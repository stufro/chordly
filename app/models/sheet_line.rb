# frozen_string_literal: true

class SheetLine
  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  def transpose(direction)
    content.split.uniq.each do |chord|
      new_chord = transpose_chord(chord, direction)
      @content = content.gsub!(chord, new_chord)
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  def transpose_chord(chord, direction)
    interval = Music::Interval.new(2, :minor)
    Music::Chord.new(chord).send("transpose_#{direction}", interval).name
  end
end
