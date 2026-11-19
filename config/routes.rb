Rails.application.routes.draw do
  get "up" => "health#up"
  get "health" => "health#show"
  resources :bookings, only: [:index, :create]

  # Onboarding flow
  resources :onboarding, only: [:show, :update]

  # Projects dashboard
  resources :projects, only: [:index, :show]

  # Root redirects to projects (which redirects to onboarding if no projects)
  root "projects#index"

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#up"
    get "health" => "health#show"
    resources :bookings, only: [:index, :create]
    resources :onboarding, only: [:show, :update]
    resources :projects, only: [:index, :show]
  end
end
