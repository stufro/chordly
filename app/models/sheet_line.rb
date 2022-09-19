class SheetLine
  include MusicUtils
  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  def transpose(direction)
    chords = content.scan(NOTE_REGEX)
    scan_start = 0
    chords.each do |chord_parts|
      old_chord = Chord.new(chord_parts)
      new_chord = transpose_chord(old_chord, direction)

      start_index = content[scan_start..-1].index(old_chord.to_s) + scan_start
      end_index = start_index + old_chord.length

      new_chord_str, end_index = adjust_chord_whitespace(old_chord, new_chord, end_index)
      @content[start_index...end_index] = new_chord_str
      scan_start = end_index + 1
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  def transpose_chord(chord, direction)
    # TODO: show error to user if chord fails to transpose
    old_note = chord.note
    old_bass_note = chord.bass_note[1..-1] if chord.bass_note # remove / char

    new_chord = chord.dup
    new_chord.note = transpose_note(old_note, direction)
    new_chord.bass_note = "/#{transpose_note(old_bass_note, direction)}" if old_bass_note.present?

    new_chord
  rescue ArgumentError
    chord
  end

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

  def adjust_chord_whitespace(chord, new_chord, end_index)
    char_diff = chord.length - new_chord.length
    spaces = " " * char_diff.abs

    end_index += char_diff.abs if char_diff.negative?
    new_chord = "#{new_chord.to_s}#{spaces}" if char_diff.positive?
    [new_chord.to_s, end_index]
  end
end
