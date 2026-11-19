class BookingsController < ActionController::API
  def index
    render json: Booking.order(:id)
  end

  def show
    booking = Booking.find(params[:id])
    render json: booking
  end

  def create
    booking = Booking.create!(params.permit(:guest, :night, :email))
    NotifyJob.perform_later(booking.id) if ENV["SIDEKIQ_ENABLED"] == "1"
    render json: booking, status: :created
  end

  def update
    booking = Booking.find(params[:id])
    booking.update!(params.permit(:guest, :night, :email))
    render json: booking
  end

  def destroy
    booking = Booking.find(params[:id])
    booking.destroy!
    head :no_content
  end
end
