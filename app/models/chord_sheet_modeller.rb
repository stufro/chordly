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
    { type: line_type(line), content: line }
  end

  def line_type(line)
    remove_ignored_chars(line).split.each { |token| extract_note!(token) }
    :chords
  rescue ArgumentError
    :lyrics
  end

  def remove_ignored_chars(line)
    line.delete("|")
        .delete(":")
        .delete("*")
        .gsub("N.C.", "")
        .gsub(/(\{.*?\}|\[.*?\])/, "") # Remove text in {} or []
  end
end
