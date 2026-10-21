module MusicUtils
  ASSUMED_OCTAVE = 5
  ACCIDENTALS = /(?:#|♯|b|♭)?/
  CHORD_TYPES = /(maj|min|m|M|sus|dim|aug|mmaj|\+|°|ø)?/
  # Captured together with any trailing sus and alterations, e.g. 7sus4 or 7b9#11
  CHORD_EXTENSIONS = %r{((?:6/9|69|11|13|2|4|5|6|7|9)?(?:sus[24]?)?(?:[#♯b♭](?:5|9|11|13))*)}
  ADD_CHORDS = /(add\d+)?/
  BASS_NOTE = %r{(?:/([A-Ga-g1-7]#{ACCIDENTALS}))?}
  # if you change NOTE_REGEX, make sure you update Chord to handle any additional parts
  NOTE_REGEX = /([A-Ga-g1-7]#{ACCIDENTALS})#{CHORD_TYPES}#{CHORD_EXTENSIONS}#{ADD_CHORDS}#{BASS_NOTE}/

  def extract_note(potential_chord)
    no_note_proc = -> { potential_chord }

    scan_chord(potential_chord, no_note_proc)
  end

  def extract_note!(potential_chord)
    no_note_proc = -> { raise(ArgumentError, "No valid note found in #{potential_chord}") }

    scan_chord(potential_chord, no_note_proc)
  end

  # The tokens on a line that should each be a chord for it to be a chord line
  def chord_tokens(line)
    line.gsub("N.C.", "")
        .gsub(/(\{.*?\}|\[.*?\])/, "") # Remove text in {} or []
        .tr("|:*.", " ")
        .scan(/[^[:space:]]+/)
        .map { |token| token.delete_prefix("(").delete_suffix(")") }
        .grep_v(/\A([x×]\d+|\d+[x×])\z/i) # Remove repeat markers like x3 or 2x
        .flat_map { |token| split_slash_separated_chords(token) }
  end

  private

  # F/Am is two chords, but G/B is one chord with a bass note
  def split_slash_separated_chords(token)
    return token if chord?(token)

    chords = token.split("/", -1)
    chords.all? { |chord| chord?(chord) } ? chords : token
  end

  def chord?(token)
    token.match?(/\A#{NOTE_REGEX}\z/)
  end

  def scan_chord(chord, no_match_proc)
    matches = chord.scan(/^#{NOTE_REGEX}$/)

    matches.empty? ? no_match_proc.call : matches.flatten.first
  end
end
