module MusicUtils
  ASSUMED_OCTAVE = 5
  ACCIDENTALS = /(?:#|b|♭)?/
  CHORD_TYPES = /(maj|min|m|sus|dim|aug|mmaj)?/
  CHORD_EXTENSIONS = /(2|4|5|6|7|9|13)?/
  ADD_CHORDS = /(add\d+)?/
  BASS_NOTE = %r{(?:/([A-Ga-g]#{ACCIDENTALS}))?}
  # if you change NOTE_REGEX, make sure you update Chord to handle any additional parts
  NOTE_REGEX = /([A-Ga-g]#{ACCIDENTALS})#{CHORD_TYPES}#{CHORD_EXTENSIONS}#{ADD_CHORDS}#{BASS_NOTE}/

  def extract_note(potential_chord)
    no_note_proc = -> { potential_chord }

    scan_chord(potential_chord, no_note_proc)
  end

  def extract_note!(potential_chord)
    no_note_proc = -> { raise(ArgumentError, "No valid note found in #{potential_chord}") }

    scan_chord(potential_chord, no_note_proc)
  end

  private

  def scan_chord(chord, no_match_proc)
    matches = chord.scan(/^#{NOTE_REGEX}$/)

    matches.empty? ? no_match_proc.call : matches.flatten.first
  end
end
