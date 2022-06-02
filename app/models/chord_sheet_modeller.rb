# frozen_string_literal: true

class ChordSheetModeller
  ASSUMED_OCTAVE = 5

  def initialize(content)
    @content = content
  end

  def parse
    content_lines = reject_empty(@content.lines)
    content_lines.map { |line| model_line(line) }
  end

  private

  def model_line(line)
    { type: line_type(line), content: sanitise(line) }
  end

  def line_type(line)
    line.split.each { |token| Music::Note.new(extract_note(token), ASSUMED_OCTAVE) }
    :chords
  rescue ArgumentError
    :lyrics
  end

  def extract_note(potential_chord)
    note = potential_chord.scan(/^[A-Ga-g][#b♭]*/)

    note.empty? ? potential_chord : note.first
  end

  def sanitise(line)
    line.gsub("\n", "")
  end

  def reject_empty(lines)
    lines.grep_v(/^\s+$/)
  end
end
