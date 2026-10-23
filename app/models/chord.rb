class Chord
  attr_accessor :note, :type, :extension, :added_tone, :bass_note

  delegate :length, to: :to_s

  def initialize(chord_parts)
    @note = chord_parts[0]
    @type = chord_parts[1]
    @extension = chord_parts[2]
    @added_tone = chord_parts[3]
    @bass_note = chord_parts[4]
  end

  def to_s
    chord = [@note, @type, @extension, @added_tone].join
    chord += "/#{@bass_note}" if @bass_note
    chord
  end

  def transpose(direction)
    new_chord = dup
    new_chord.note = transpose_note(@note, direction)
    new_chord.bass_note = transpose_note(@bass_note, direction) if @bass_note

    new_chord
  end

  def normalised
    new_chord = dup
    new_chord.note = normalise_note(@note)
    new_chord.bass_note = normalise_note(@bass_note) if @bass_note

    new_chord
  end

  def nashville_number?
    note.match?(/^\d$/)
  end

  private

  def transpose_note(note, direction)
    return note if note.match?(/\A\d\z/) # A number, like the 4 in Csus2/4, isn't a note

    new_note = Music::Note.new(normalise_accidental(note), 5).send(method_for(direction))
    [new_note.letter, new_note.accidental].join
  end

  def normalise_note(note)
    normalise_accidental(note).capitalize
  end

  def normalise_accidental(note)
    note.tr("♭♯", "b#")
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
