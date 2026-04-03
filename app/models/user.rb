class User < ApplicationRecord
  include Flipper::Identifier

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :chord_sheets, dependent: :destroy
  has_many :set_lists, dependent: :destroy

  before_create :populate_uuid

  enum :user_type, { standard: "standard", admin: "admin", ad_free: "ad_free" }, default: :standard

  SUPPORT_TOAST_SIGN_IN_THRESHOLD = 5
  SUPPORT_TOAST_SNOOZE_PERIOD     = 3.months
  SUPPORT_TOAST_MIN_ACCOUNT_AGE   = 1.month

  def show_support_toast?
    return false if created_at > SUPPORT_TOAST_MIN_ACCOUNT_AGE.ago
    return false if sign_in_count < SUPPORT_TOAST_SIGN_IN_THRESHOLD
    return false if support_toast_dismissed_at.present? &&
                    support_toast_dismissed_at > SUPPORT_TOAST_SNOOZE_PERIOD.ago

    true
  end

  def deleted_content?
    chord_sheets.deleted.present? || set_lists.deleted.present?
  end

  private

  def populate_uuid
    self.uuid = SecureRandom.uuid
  end
end
