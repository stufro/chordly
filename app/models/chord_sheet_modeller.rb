class ChordSheetModeller
  def initialize(content)
    @content = content
  end

  def build
    content_lines = reject_empty(@content.lines)
    content_lines.map {|line| model_line(line) }
  end

  private

  def model_line(line)
    { type: line_type(line), content: sanitise(line) }
  end

  def line_type(line)
    line.split.each {|token| Music::Chord.new(token) }
    :chords
  rescue StandardError
    :lyrics
  end

  def sanitise(line)
    line.gsub("\n", "")
  end

  def reject_empty(lines)
    lines.reject {|line| line.match? /^\s+$/ }
  end
end