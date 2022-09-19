class Chord
  attr_accessor :note, :type, :extension, :bass_note

  def initialize(chord_parts)
    @note = chord_parts[0]
    @type = chord_parts[1]
    @extension = chord_parts[2]
    @bass_note = chord_parts[3]
  end

  def to_s
    [@note, @type, @extension, bass_note].join
  end

  def length
    to_s.length
  end
end