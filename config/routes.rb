Rails.application.routes.draw do
  devise_for :admins, sign_out_via: [:get, :delete]

  resources :users
  get "/main", to: "main#index"
  get "/user_rewards", to: "user_reward#index"

  namespace :api do
    namespace :offerwall do
      post "completeCampaign", to: "offerwall#complete_campaign"
    end
  end

  root "main#index"

  match '*unmatched', to: 'application#not_found_method', via: :all
end
