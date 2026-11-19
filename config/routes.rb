Rails.application.routes.draw do
  get "up" => "health#show"
  resources :bookings, only: [:index, :create]

  resource :waiting_list, only: [:new, :create]

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#show"
    resources :bookings, only: [:index, :create]
    resource :waiting_list, only: [:new, :create]
    get "landing_page" => "pages#landing_page"

    namespace :admin do
      resources :users, only: [:index, :show, :update, :destroy]
    end
  end
end
