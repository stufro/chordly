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

  belongs_to :styleable, polymorphic: true

  enum :line_type, %w[chords lyrics heading].index_by(&:itself), validate: true
  enum :font_style, FONT_STYLES.keys.index_by(&:itself), validate: true
  enum :colour, COLOURS.keys.index_by(&:itself), validate: { allow_nil: true }

  validates :line_type, uniqueness: { scope: %i[styleable_type styleable_id] }
end
