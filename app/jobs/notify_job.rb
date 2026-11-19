class NotifyJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    Rails.logger.info("booking #{booking.id}: #{booking.guest} on #{booking.night}")
  end
end
