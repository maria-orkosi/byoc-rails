Rails.application.routes.draw do
  get "up" => "health#show"
  resources :bookings, only: [:index, :create]

  # Public pages rendered with the analytics-enabled layout.
  root "pages#home"
  get "home" => "pages#home"

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#show"
    resources :bookings, only: [:index, :create]
    resources :registrations, only: [:create]
  end
end
