# Line types drive per-type styling and compacting, so after changing these rules run
# `bin/rails chord_sheets:reclassify_lines` on production (with DRY_RUN=1 first).
#
# A section label followed by chords, like "Intro: G C D", is chords because chord_tokens
# strips the label; one followed by words, like "Chorus: la la", is lyrics.
# Known limitation: lyric lines made only of chord-like words, like "A" or "1 2 3 4", come out as chords.
class ChordSheetModeller
  include MusicUtils

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
