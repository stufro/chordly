class ChordSheet < ApplicationRecord
  belongs_to :user, optional: true
  has_many :chord_sheets_set_list, dependent: :destroy
  has_many :set_lists, through: :chord_sheets_set_list

  validates :name, presence: true
  validates :content, presence: true

  has_paper_trail limit: 15

  scope :not_deleted, -> { where(deleted: [false, nil]) }
  scope :deleted, -> { where(deleted: true) }

  def transpose(direction)
    content.map! do |line_hash|
      line = SheetLine.new(line_hash)
      next(line) unless line.chords?

      line.transpose(direction)
    end
    self
  end

  def unique_chords
    chord_lines = content.select { |line| line["type"] == "chords" }
    chord_lines.flat_map { |line| line["content"].split }.uniq
  end
end
