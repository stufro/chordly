class User < ApplicationRecord
  include Flipper::Identifier

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :chord_sheets, dependent: :destroy
  has_many :set_lists, dependent: :destroy

  before_create :populate_uuid

  def deleted_content?
    chord_sheets.deleted.present? || set_lists.deleted.present?
  end

  private

  def populate_uuid
    self.uuid = SecureRandom.uuid
  end
end
