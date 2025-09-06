require "chordpro"

class ChordProConverter
  delegate :title, to: :song

  def initialize(content)
    @song = Chordpro.parse(content)
  end

  def body
    song.elements.filter_map do |el|
      case el
      when Chordpro::Directive
        "[#{el.value}]" if el.name.to_s == "c" # verse/chorus markers

      when Chordpro::Line
        separate_chords_and_lyrics(el)

      when Chordpro::Linebreak
        "\n"
      end
    end.drop_while(&:blank?).join("\n")
  end

  private

  attr_reader :song

  def separate_chords_and_lyrics(line)
    chords_line, lyrics_line = build_line(line)
    lines = []
    lines << chords_line.rstrip unless chords_line.strip.empty?
    lines << lyrics_line.rstrip
    lines.join("\n")
  end

  # rubocop:disable Metrics/AbcSize
  def build_line(line)
    line.parts.reduce(["", ""]) do |(chords, lyrics), part|
      if part.is_a?(Chordpro::Chord)
        [chords + part.name, lyrics]
      elsif part.is_a?(Chordpro::Lyric)
        previous_chord_length = chords.split.last&.length || 0
        [chords + (" " * (part.text.length - previous_chord_length)), lyrics + part.text]
      else
        [chords, lyrics]
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
end
