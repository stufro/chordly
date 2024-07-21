class User < ApplicationRecord
  include Flipper::Identifier

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :chord_sheets, dependent: :destroy
  has_many :set_lists, dependent: :destroy

  def deleted_content?
    chord_sheets.deleted.present? || set_lists.deleted.present?
  end
end
