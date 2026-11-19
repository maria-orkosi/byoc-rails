Rails.application.routes.draw do
  get "up" => "health#show"
  resources :bookings, only: [:index, :create]

  # Sessions (dev login)
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#show"
    resources :bookings, only: [:index, :create]
    resources :components, only: [:index]
  end
end
