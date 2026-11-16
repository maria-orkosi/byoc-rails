Rails.application.routes.draw do
  get "up" => "health#show"
  resources :bookings, only: [:index, :create]
end
