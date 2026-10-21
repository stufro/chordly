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
    remove_ignored_chars(line).scan(/[^[:space:]]+/).each { |token| extract_note!(token) }
    :chords
  rescue ArgumentError
    :lyrics
  end

  def remove_ignored_chars(line)
    line.tr("|:*", " ")
        .gsub("N.C.", "")
        .gsub(/(\{.*?\}|\[.*?\])/, "") # Remove text in {} or []
  end
end
