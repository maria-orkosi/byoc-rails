Rails.application.routes.draw do
  get "up" => "health#show"
  resources :bookings, only: [:index, :show, :create, :update, :destroy]

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#show"
    resources :bookings, only: [:index, :show, :create, :update, :destroy]
  end
end
