Rails.application.routes.draw do
  root "components#index"
  get "up" => "health#show"
  resources :bookings, only: [:index, :create]

  resources :components, only: [:index, :show]
  resources :projects do
    resources :component_groups, only: [:create, :update, :destroy]
    resources :project_components, only: [:create, :update, :destroy] do
      collection do
        patch :reorder
      end
    end
  end

  # The same API under /api: the host router of a product with a frontend maps /api to this part.
  scope "/api" do
    get "up" => "health#show"
    resources :bookings, only: [:index, :create]
    resources :components, only: [:index, :show]
    resources :projects do
      resources :component_groups, only: [:create, :update, :destroy]
      resources :project_components, only: [:create, :update, :destroy] do
        collection do
          patch :reorder
        end
      end
    end
  end
end
