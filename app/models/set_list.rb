class SetList < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :chord_sheets_set_list, dependent: :destroy
  has_many :chord_sheets, through: :chord_sheets_set_list
end
