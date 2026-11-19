class Booking < ApplicationRecord
  validates :guest, :night, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
end
