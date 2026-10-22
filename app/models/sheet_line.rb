class SheetLine
  include MusicUtils

  attr_accessor :type, :content

  def initialize(line_hash)
    @type = line_hash["type"]
    @content = line_hash["content"]
  end

  def transpose(direction)
    # Match ignored text (N.C. and text in {} or []) first so chord letters inside it are left alone,
    # and only match whole chords so part of an unrecognised chord isn't transposed.
    # The o flag compiles the interpolated regex once rather than on every call.
    @content = content.gsub(/N\.C\.|\{.*?\}|\[.*?\]|(?<![[:alnum:]])#{NOTE_REGEX}(?![[:alnum:]])( *)/o) do |match|
      chord_parts = Regexp.last_match.captures
      old_chord = Chord.new(chord_parts)
      next match if old_chord.note.nil? || old_chord.nashville_number?

      new_chord = old_chord.transpose(direction)
      end_of_line = Regexp.last_match.post_match.blank?
      "#{new_chord}#{adjust_whitespace(old_chord, new_chord, chord_parts.last, end_of_line:)}"
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  # A longer chord absorbs following spaces if a space would still separate it from the next chord
  def adjust_whitespace(old_chord, new_chord, spaces, end_of_line:)
    char_diff = old_chord.length - new_chord.length

    if old_chord_longer_than_new?(char_diff)
      spaces + (" " * char_diff)
    elsif new_chord_longer_than_old?(char_diff) && (end_of_line || spaces.length > char_diff.abs)
      spaces[char_diff.abs..].to_s
    else
      spaces
    end
  end

  def new_chord_longer_than_old?(char_diff)
    char_diff.negative?
  end

  def old_chord_longer_than_new?(char_diff)
    char_diff.positive?
  end
end
