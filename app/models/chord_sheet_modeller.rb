class ChordSheetModeller
  include MusicUtils

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

    tokens = chord_tokens(line)
    return :heading if tokens.empty? && line.match?(/\{.*?\}|\[.*?\]/) # Only text in {} or [], like [Verse 1]

    # Lines with no tokens left, like | . . . | or N.C., are chord notation so stay chords
    tokens.each { |token| extract_note!(token) }
    :chords
  rescue ArgumentError
    :lyrics
  end
end
