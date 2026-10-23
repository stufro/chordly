module MusicUtils
  ASSUMED_OCTAVE = 5
  ACCIDENTALS = /(?:#|♯|b|♭)?/
  CHORD_TYPES = /(maj|min|m|M|sus|dim|aug|mmaj|mMaj|mM|\+|°|ø)?/
  # Captured together with any trailing sus and alterations, e.g. 7sus4, 7b9#11 or 7+5
  CHORD_EXTENSIONS = %r{((?:6/9|69|11|13|2|4|5|6|7|9)?(?:sus[24]?)?(?:[#♯b♭+](?:5|9|11|13))*)}
  ADD_CHORDS = /(add\d+)?/
  # The atomic group keeps a bass note's accidental, so in Am/F#m the F# isn't read as a bass F
  BASS_NOTE = %r{(?:/([A-Ga-g1-7](?>#{ACCIDENTALS})))?}
  # if you change NOTE_REGEX, make sure you update Chord to handle any additional parts
  NOTE_REGEX = /([A-Ga-g1-7]#{ACCIDENTALS})#{CHORD_TYPES}#{CHORD_EXTENSIONS}#{ADD_CHORDS}#{BASS_NOTE}/
  CHORD_REGEX = /\A#{NOTE_REGEX}\z/
  SECTION_NAMES = /intro|verse|pre[-\s]?chorus|post[-\s]?chorus|chorus|bridge|middle\s(?:8|eight)|breakdown|break|
                   interlude|instrumental|(?:(?:guitar|piano|keys|bass|sax)\s)?solo|outro|coda|ending|refrain|
                   hook|tag|vamp|turnaround/ix
  # A section label at the start of a chord line, like "Intro:" in "Intro: G C D"
  LEADING_SECTION_LABEL = /\A\s*\(?(?:#{SECTION_NAMES})(?: \d+)?\)?:?(?=\s|\z)/

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
    line.sub(LEADING_SECTION_LABEL, "")
        .gsub("N.C.", "")
        .gsub(/(\{.*?\}|\[.*?\])/, "") # Remove text in {} or []
        .tr("|:*.", " ")
        .scan(/[^[:space:]]+/)
        .map { |token| token.delete_prefix("(").delete_suffix(")") }
        .grep_v(/\A([x×]\d+|\d+[x×])\z/i) # Remove repeat markers like x3 or 2x
        .then { |tokens| without_separators(tokens) }
        .flat_map { |token| split_slash_separated_chords(token) }
  end

  private

  # A dash or slash between chords, like C - F / G, separates them, but a line of only those isn't chords
  def without_separators(tokens)
    others = tokens.grep_v(%r{\A[-/]\z})
    others.empty? ? tokens : others
  end

  # F/Am is two chords, but G/B is one chord with a bass note
  def split_slash_separated_chords(token)
    return token if chord?(token)

    chords = token.split("/", -1)
    chords.all? { |chord| chord?(chord) } ? chords : token
  end

  def chord?(token)
    token.match?(CHORD_REGEX)
  end

  def scan_chord(chord, no_match_proc)
    matches = chord.scan(CHORD_REGEX)

    matches.empty? ? no_match_proc.call : matches.flatten.first
  end
end
