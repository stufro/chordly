class ChordSheet < ApplicationRecord
  belongs_to :user, optional: true

  scope :for_user, ->(user) { where(user:) }

  def transpose(direction)
    content.map! do |line_hash|
      line = SheetLine.new(line_hash)
      next(line) unless line.chords?

      line.transpose(direction)
    end
    self
  end
end
