class SheetLine
  include MusicUtils
  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  def transpose(direction)
    chords = content.scan(/([A-Ga-g][#b♭]?)#{CHORD_TYPES}#{CHORD_EXTENSIONS}/)
    scan_start = 0
    chords.each do |chord_parts|
      old_chord = chord_parts.join
      new_chord = transpose_chord(chord_parts, direction)

      start_index = content[scan_start..-1].index(old_chord) + scan_start
      end_index = start_index + old_chord.length

      end_index += 1 if has_accidental?(new_chord) && !has_accidental?(old_chord)
      old_chord, new_chord = adjust_chord_whitespace(old_chord, new_chord)
      @content[start_index...end_index] = new_chord
      scan_start = end_index + 1
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  def transpose_chord(chord_parts, direction)
    # TODO: show error to user if chord fails to transpose
    old_note = chord_parts.first
    new_note = Music::Note.new(old_note, 5).send(method_for(direction))
    new_note = [new_note.letter, new_note.accidental].join
    ([new_note] + chord_parts[1..-1]).join
  rescue ArgumentError
    chord_parts.join
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
    chord = /#{chord} ?/ if has_accidental?(new_chord) && !has_accidental?(chord)
    new_chord = "#{new_chord} " if !has_accidental?(new_chord) && has_accidental?(chord)

    [chord, new_chord]
  end
end
