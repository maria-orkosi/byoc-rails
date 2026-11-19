Rails.application.routes.draw do
  get "up" => "health#show"
  resources :bookings, only: [:index, :create]

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#show"
    resources :bookings, only: [:index, :create]
  end
end
