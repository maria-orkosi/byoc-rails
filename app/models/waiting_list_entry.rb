class WaitingListEntry < ApplicationRecord
  before_validation :normalize_email

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { case_sensitive: false }
  validates :subscribed_at, presence: true

  private

  def normalize_email
    self.email = email.to_s.strip.downcase if email.present?
  end
end