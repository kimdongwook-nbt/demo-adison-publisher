Rails.application.routes.draw do
  devise_for :admins, sign_out_via: [:get, :post]

  # users
  resources :users
  # get   '/users',     to: 'users#index'
  # get   '/users/new', to: 'users#new'
  # get   '/users/:id', to: 'users#show'
  # post  '/users',     to: 'users#create'

  namespace :api do
    namespace :offerwall do
      post "completeCampaign", to: "offerwall#complete_campaign"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/main", to: "main#index"
  root "main#index"
end
