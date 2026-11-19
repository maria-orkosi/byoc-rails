# @custom onboarding routes — registered through the @custom route mechanism
Rails.application.routes.append do
  resource :onboarding, only: [:show], controller: "onboarding" do
    post :start
    post :advance
    post :skip
  end
end

Rails.application.routes.append do
  scope "/api" do
    resource :onboarding, only: [:show], controller: "onboarding" do
      post :start
      post :advance
      post :skip
    end
  end
end