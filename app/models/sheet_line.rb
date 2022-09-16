# frozen_string_literal: true

class SheetLine
  include MusicUtils
  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  def transpose(direction)
    chords = content.split.uniq.sort.reverse

    chords.each do |chord|
      new_chord = transpose_chord(chord, direction)
      chord, new_chord = adjust_chord_whitespace(chord, new_chord)
      @content = content.gsub(chord, new_chord)
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  def transpose_chord(chord, direction)
    # TODO: show error to user if chord fails to transpose
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

  def adjust_chord_whitespace(chord, new_chord)
    chord = /#{chord} ?/ if new_chord.match?(/[#b♭]/) && !chord.match?(/[#b♭]/)
    new_chord = "#{new_chord} " if !new_chord.match?(/[#b♭]/) && chord.match?(/[#b♭]/)

    [chord, new_chord]
  end
end
