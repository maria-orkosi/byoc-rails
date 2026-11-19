class WaitingListController < ActionController::API
  def new
    render json: { message: "Waiting list signup form" }
  end

  def create
    email = params[:email].to_s.strip.downcase

    # Check for duplicate by email before creating
    if WaitingListEntry.exists?(email: email)
      render json: { message: "You're already on the list!" }, status: :ok
      return
    end

    entry = WaitingListEntry.new(email: email, subscribed_at: Time.current)

    if entry.save
      render json: { message: "You're on the list!" }, status: :created
    else
      if entry.errors.of_kind?(:email, :taken)
        render json: { message: "You're already on the list!" }, status: :ok
      else
        render json: { message: "Please enter a valid email" }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { message: "You're already on the list!" }, status: :ok
  end
end