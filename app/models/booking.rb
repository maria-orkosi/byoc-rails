class Booking < ApplicationRecord
  validates :guest, :night, presence: true
end
