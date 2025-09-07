class ChordProConverter
  delegate :title, to: :song

  def initialize(content)
    stripped_content = content.lines.map(&:strip).join("\n")
    @song = Chordpro.parse(stripped_content)
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
    lines.join("\r\n")
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
  def build_line(line)
    line.parts.reduce(["", ""]) do |(chords, lyrics), part|
      if part.is_a?(Chordpro::Chord)
        clean_name = part.name.gsub(/\.+$/, "")

        # if last char of chords is not whitespace, add a space before new chord
        needs_space = chords[-1] && chords[-1] != " "

        new_chords = chords + (needs_space ? " " : "") + clean_name
        [new_chords, lyrics]
      elsif part.is_a?(Chordpro::Lyric)
        previous_chord_length = chords.split.last&.length || 0
        padding = [part.text.length - previous_chord_length, 0].max
        [chords + (" " * padding), lyrics + part.text]
      else
        [chords, lyrics]
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
