class Chord
  attr_accessor :note, :type, :extension, :bass_note

  def initialize(chord_parts)
    @note = chord_parts[0]
    @type = chord_parts[1]
    @extension = chord_parts[2]
    @bass_note = chord_parts[3]
  end

  def to_s
    chord = [@note, @type, @extension].join
    chord += "/#{@bass_note}" if @bass_note
    chord
  end

  def length
    to_s.length
  end

  def transpose(direction)
    new_chord = dup
    new_chord.note = transpose_note(@note, direction)
    new_chord.bass_note = transpose_note(@bass_note, direction) if @bass_note

    new_chord
  end

  private

  def transpose_note(note, direction)
    new_note = Music::Note.new(note, 5).send(method_for(direction))
    [new_note.letter, new_note.accidental].join
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