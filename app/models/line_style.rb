class LineStyle < ApplicationRecord
  # Mid-tones so each colour reads on both the light and dark themes
  COLOURS = {
    "red" => "#e03131",
    "orange" => "#e8590c",
    "green" => "#2f9e44",
    "blue" => "#1c7ed6",
    "purple" => "#ae3ec9",
    "grey" => "#868e96"
  }.freeze

  # Each sets the weight so italics aren't bold on line types that are bold by default
  FONT_STYLES = {
    "normal" => "font-weight: normal",
    "bold" => "font-weight: bold",
    "italic" => "font-weight: normal; font-style: italic",
    "bold_italic" => "font-weight: bold; font-style: italic"
  }.freeze

  # Relative, so headings scale with the chord sheet's text size on the page and in PDFs.
  # In ems because sghtmltopdf ignores percentage font sizes.
  FONT_SIZES = {
    "normal" => "1em",
    "large" => "1.25em",
    "larger" => "1.5em",
    "largest" => "2em"
  }.freeze

  belongs_to :styleable, polymorphic: true

  enum :line_type, %w[chords lyrics heading].index_by(&:itself), validate: true
  enum :font_style, FONT_STYLES.keys.index_by(&:itself), validate: true
  enum :font_size, FONT_SIZES.keys.index_by(&:itself), validate: { allow_nil: true }, prefix: true
  enum :colour, COLOURS.keys.index_by(&:itself), validate: { allow_nil: true }

  validates :line_type, uniqueness: { scope: %i[styleable_type styleable_id] }
  # Sizing chord or lyric lines would push chords out of line with the words above
  validates :font_size, absence: true, unless: :heading?

  def self.default_for(line_type)
    new(line_type:, font_style: line_type == "lyrics" ? "normal" : "bold")
  end

  # Whether it looks the same as the built-in style. A normal size renders the same as none.
  def default?
    font_style == self.class.default_for(line_type).font_style && colour.nil? && (font_size.nil? || font_size_normal?)
  end
end
