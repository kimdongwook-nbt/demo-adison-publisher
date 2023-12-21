Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  get '/admins', to: "admins#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
