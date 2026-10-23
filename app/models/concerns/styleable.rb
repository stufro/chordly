module Styleable
  extend ActiveSupport::Concern

  # Absolute, so the text is the same size on the page and in PDFs. Chords and lyrics share it
  # so chords stay above the right words, and headings are sized relative to it.
  TEXT_SIZES = {
    "small" => "12px",
    "normal" => "14px",
    "large" => "16px",
    "larger" => "18px"
  }.freeze

  included do
    has_many :line_styles, as: :styleable, dependent: :destroy

    enum :text_size, TEXT_SIZES.keys.index_by(&:itself), validate: true, prefix: true
  end

  # Finds in memory so rendering every line doesn't query, falling back to an unsaved default style
  def line_style_for(line_type)
    line_styles.find { it.line_type == line_type } || LineStyle.default_for(line_type)
  end

  # Saving the style form stores every line type, so compare against the built-in styles
  def styled?
    !text_size_normal? || line_styles.any? { !it.default? }
  end

  # Back to the built-in styles, with no line styles of its own
  def reset_styles
    transaction do
      line_styles.destroy_all
      update!(text_size: "normal")
    end
  end

  # Copies rather than links, so each can then be changed on its own
  def copy_styles_from(other)
    self.text_size = other.text_size
    self.line_styles = other.line_styles.map(&:dup)
  end
end
