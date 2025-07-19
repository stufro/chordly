class SheetLine
  include MusicUtils
  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  # rubocop:disable Metrics/MethodLength
  def transpose(direction)
    chords = sanitised_content.scan(NOTE_REGEX)
    scan_start = 0
    chords.each do |chord_parts|
      old_chord = Chord.new(chord_parts)
      next if old_chord.nashville_number?

      new_chord = old_chord.transpose(direction)

      chord_start_index, chord_end_index = calculate_range_to_replace(scan_start, old_chord, new_chord)
      new_chord_str = adjust_chord_whitespace(old_chord, new_chord)
      @content[chord_start_index...chord_end_index] = new_chord_str
      scan_start = chord_end_index + 1
    end
    self
  end
  # rubocop:enable Metrics/MethodLength

  def chords?
    type == "chords"
  end

  private

  def sanitised_content
    content.dup.gsub("N.C.", "")
  end

  def calculate_range_to_replace(scan_start, old_chord, new_chord)
    chord_start_index = @content[scan_start..].index(old_chord.to_s) + scan_start
    chord_end_index = adjust_end_for_whitespace(chord_start_index, old_chord, new_chord)
    [chord_start_index, chord_end_index]
  end

  def adjust_end_for_whitespace(start_index, old_chord, new_chord)
    char_diff = old_chord.length - new_chord.length
    chord_end_index = start_index + old_chord.length

    if new_chord_longer_than_old?(char_diff) && sufficient_whitespace?(char_diff, chord_end_index)
      chord_end_index + char_diff.abs
    else
      chord_end_index
    end
  end

  def sufficient_whitespace?(char_diff, chord_end_index)
    new_chord_end_index = chord_end_index + char_diff.abs
    @content[chord_end_index..new_chord_end_index].match?(/^\s+$/)
  end

  def adjust_chord_whitespace(old_chord, new_chord)
    char_diff = old_chord.length - new_chord.length
    spaces = " " * char_diff.abs

    new_chord = "#{new_chord}#{spaces}" if old_chord_longer_than_new?(char_diff)
    new_chord.to_s
  end

  def new_chord_longer_than_old?(char_diff)
    char_diff.negative?
  end

  def old_chord_longer_than_new?(char_diff)
    char_diff.positive?
  end
end
