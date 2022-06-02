# frozen_string_literal: true

module MusicUtils
  ASSUMED_OCTAVE = 5
  ACCIDENTALS = "(#|##|b|bb|♭|♭♭)?"
  CHORD_TYPES = "(maj|5|maj7|7|min|m|min7|m7|sus4|sus2)?"
  NOTE_REGEX = /^([A-Ga-g]#{ACCIDENTALS})#{CHORD_TYPES}$/

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
    matches = chord.scan(NOTE_REGEX)

    matches.empty? ? no_match_proc.call : matches.flatten.first
  end
end
