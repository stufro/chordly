class ChordSheetModeller
  include MusicUtils

  SECTION_NAMES = /intro|verse|pre[-\s]?chorus|post[-\s]?chorus|chorus|bridge|middle\s(?:8|eight)|breakdown|break|
                   interlude|instrumental|(?:(?:guitar|piano|keys|bass|sax)\s)?solo|outro|coda|ending|refrain|
                   hook|tag|vamp|turnaround/ix
  REPEAT_MARKER = /\(?(?:repeat|[x×] ?\d+|\d+ ?[x×])\)?/
  # A whole line naming a section, like "Verse 1:", "(Bridge)", "Chorus x2" or "Repeat Chorus"
  SECTION_LABEL = /\A(?:repeat )?\(?(?:#{SECTION_NAMES})(?: \d+)?\)?:? ?#{REPEAT_MARKER}?\z/io

  def initialize(content)
    @content = content
  end

  def parse
    @content.lines.map { |line| model_line(line) }
  end

  private

  def model_line(line)
    type = line_type(line)
    line = line.gsub("　", "  ") if type == :chords # Ideographic spaces are two columns wide

    { type:, content: line }
  end

  def line_type(line)
    return :lyrics if line.blank?
    return :heading if line.strip.match?(SECTION_LABEL)

    tokens = chord_tokens(line)
    return :heading if tokens.empty? && line.match?(/\{.*?\}|\[.*?\]/) # Only text in {} or [], like [Verse 1]

    # Lines with no tokens left, like | . . . | or N.C., are chord notation so stay chords
    tokens.each { |token| extract_note!(token) }
    :chords
  rescue ArgumentError
    :lyrics
  end
end
