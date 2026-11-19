class WaitingListEntry < ApplicationRecord
  STATUSES = %w[active deactivated].freeze

  before_validation :normalize_email

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { case_sensitive: false }
  validates :subscribed_at, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :active, -> { where(status: "active") }
  scope :deactivated, -> { where(status: "deactivated") }
  scope :order_by_name_asc, -> { order(name: :asc) }
  scope :order_by_name_desc, -> { order(name: :desc) }
  scope :order_by_email_asc, -> { order(email: :asc) }
  scope :order_by_email_desc, -> { order(email: :desc) }
  scope :order_by_created_at_asc, -> { order(created_at: :asc) }
  scope :order_by_created_at_desc, -> { order(created_at: :desc) }

  def active?
    status == "active"
  end

  def deactivated?
    status == "deactivated"
  end

  def deactivate!
    update!(status: "deactivated")
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase if email.present?
  end
end