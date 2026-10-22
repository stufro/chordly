class ChordSheet < ApplicationRecord
  include MusicUtils
  include Styleable

  belongs_to :user, optional: true
  has_many :chord_sheets_set_list, dependent: :destroy
  has_many :set_lists, through: :chord_sheets_set_list

  accepts_nested_attributes_for :line_styles

  validates :name, presence: true
  validates :content, presence: true

  has_paper_trail limit: 15

  scope :not_deleted, -> { where(deleted: [false, nil]) }
  scope :deleted, -> { where(deleted: true) }

  serialize :content, coder: JSON

  delegate :email, to: :user, prefix: true, allow_nil: true

  def transpose(direction)
    content.map! do |line_hash|
      line = SheetLine.new(line_hash)
      next(line) unless line.chords?

      line.transpose(direction)
    end
    self
  end

  # Removes blank lines, keeping one before each heading after the first line to separate sections
  def compact
    self.content = content.reject.with_index do |line, index|
      line["content"].blank? && (index.zero? || content[index + 1]&.dig("type") != "heading")
    end
    self
  end

  def sections
    content.slice_after { |line| line["content"].blank? }.to_a
  end

  def unique_chords
    chord_lines = content.select { |line| line["type"] == "chords" }
    chord_lines.flat_map do |line|
      chord_tokens(line["content"]).map { |token| normalise_chord(token) }
    end.uniq
  end

  private

  def normalise_chord(token)
    chord_parts = token.match(CHORD_REGEX)&.captures
    chord_parts ? Chord.new(chord_parts).normalised.to_s : token
  end
end
