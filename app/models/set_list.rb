class SetList < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :chord_sheets_set_list, dependent: :destroy
  has_many :chord_sheets, through: :chord_sheets_set_list

  def next_position
    chord_sheets_set_list.pluck(:position).max.to_i + 1
  end

  def refresh_positions
    chord_sheets_set_list.each_with_index do |record, index|
      record.update(position: index + 1)
    end
  end
end
