Rails.application.routes.draw do
  root "admins#index"

  get '/admins', to: "admins#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
