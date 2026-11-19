class BookingsController < ActionController::API
  def index
    render json: Booking.order(:id)
  end

  def create
    booking = Booking.create!(params.permit(:guest, :night))
    NotifyJob.perform_later(booking.id) if ENV["SIDEKIQ_ENABLED"] == "1"
    render json: booking, status: :created
  end
end
