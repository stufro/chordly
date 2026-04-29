class User < ApplicationRecord
  include Flipper::Identifier

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :chord_sheets, dependent: :destroy
  has_many :set_lists, dependent: :destroy

  before_create :populate_uuid

  enum :user_type, { standard: "standard", admin: "admin", ad_free: "ad_free" }, default: :standard

  SUPPORT_TOAST_SIGN_IN_THRESHOLD = 2
  SUPPORT_TOAST_SNOOZE_PERIOD     = 3.months
  SUPPORT_TOAST_MIN_ACCOUNT_AGE   = 2.weeks

  def self.support_toast_stats(except:)
    users = where.not(id: except.id)
    {
      eligible_count: users.support_toast_eligible.count,
      seen_count: users.support_toast_seen.count,
      dismissed_count: users.support_toast_dismissed.count,
      clicked_count: users.support_toast_clicked.count,
      clicked_users: users.support_toast_clicked.order(support_toast_clicked_at: :desc)
    }
  end

  scope :support_toast_seen,      -> { where.not(support_toast_shown_at: nil) }
  scope :support_toast_dismissed, -> { where.not(support_toast_dismissed_at: nil) }
  scope :support_toast_clicked,   -> { where.not(support_toast_clicked_at: nil) }
  scope :support_toast_eligible, lambda {
    where(created_at: ..SUPPORT_TOAST_MIN_ACCOUNT_AGE.ago)
      .where(sign_in_count: SUPPORT_TOAST_SIGN_IN_THRESHOLD..)
      .where(
        "support_toast_dismissed_at IS NULL OR support_toast_dismissed_at <= ?",
        SUPPORT_TOAST_SNOOZE_PERIOD.ago
      )
  }

  def record_support_toast_action(action_type)
    case action_type
    when "show"    then update(support_toast_shown_at: Time.current) if support_toast_shown_at.nil?
    when "dismiss" then update(support_toast_dismissed_at: Time.current)
    when "click"   then update(support_toast_clicked_at: Time.current)
    end
  end

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
