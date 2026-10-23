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
    # Closing brackets are matched with the chord so spaces are added or taken after them.
    # The o flag compiles the interpolated regex once rather than on every call.
    @carried_diff = 0
    @content = content.gsub(/N\.C\.|\{.*?\}|\[.*?\]|(?<![[:alnum:]])#{NOTE_REGEX}(?![[:alnum:]])(\)*)( *)/o) do |match|
      transpose_match(Regexp.last_match, direction) || match
    end
    self
  end

  def chords?
    type == "chords"
  end

  private

  def transpose_match(match_data, direction)
    old_chord = Chord.new(match_data.captures)
    return if old_chord.note.nil? || old_chord.nashville_number?

    new_chord = old_chord.transpose(direction)
    char_diff = old_chord.length - new_chord.length + @carried_diff
    @carried_diff = slash_carried_diff(char_diff, match_data.post_match)
    return new_chord.to_s if @carried_diff.positive?

    "#{new_chord}#{text_after_chord(match_data, char_diff)}"
  end

  def text_after_chord(match_data, char_diff)
    closing_brackets, spaces = match_data.captures.last(2)
    closing_brackets + adjust_whitespace(char_diff, spaces, end_of_line: match_data.post_match.blank?)
  end

  # A shortened chord before a slash, like the Bb in Bb/Am, passes its spare space to the chord after the slash
  def slash_carried_diff(char_diff, post_match)
    old_chord_longer_than_new?(char_diff) && post_match.match?(%r{\A/[A-Ga-g]}) ? char_diff : 0
  end

  # A longer chord absorbs following spaces if a space would still separate it from the next chord
  def adjust_whitespace(char_diff, spaces, end_of_line:)
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
