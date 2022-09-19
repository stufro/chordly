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
      old_chord = chord_parts.join
      new_chord = transpose_chord(chord_parts, direction)

      start_index = content[scan_start..-1].index(old_chord) + scan_start
      end_index = start_index + old_chord.length

      new_chord, end_index = adjust_chord_whitespace(old_chord, new_chord, end_index)
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
    old_bass_note = chord_parts[3][1..-1] if chord_parts[3] # remove / char
    new_note = transpose_note(old_note, direction)
    new_bass_note = transpose_note(old_bass_note, direction) if old_bass_note.present?

    chord_parts[3] = nil # clear bass note before appending all parts to new note
    new_chord = [new_note] + chord_parts[1..-1]
    new_chord += ["/", new_bass_note] if old_bass_note.present? # add on bass note with / char
    new_chord.join
  rescue ArgumentError
    chord_parts.join
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
    new_chord = "#{new_chord}#{spaces}" if char_diff.positive?
    [new_chord, end_index]
  end
end
