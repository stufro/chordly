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
    remove_bar_chars(line).split.each { |token| extract_note!(token) }
    :chords
  rescue ArgumentError
    :lyrics
  end

  def remove_bar_chars(line)
    line.delete("|")
        .delete(":")
  end
end
