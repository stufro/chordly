# frozen_string_literal: true

class SheetLine
  include MusicUtils
  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  def transpose(direction)
    content.split.uniq.each do |chord|
      new_chord = transpose_chord(chord, direction)
      @content = content.gsub(chord, new_chord)
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  def transpose_chord(chord, direction)
    # TODO: , make extract_note throw exception if no note is found
    old_note = extract_note!(chord)
    new_note = Music::Note.new(old_note, 5).send(method_for(direction))
    new_note = [new_note.letter, new_note.accidental].join

    chord.gsub(old_note, new_note)
  rescue ArgumentError
    chord
  end

  def method_for(direction)
    case direction.to_sym
    when :up
      :succ
    when :down
      :prev
    end
  end
end
