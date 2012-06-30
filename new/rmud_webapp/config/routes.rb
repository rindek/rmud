RmudWebapp::Application.routes.draw do
  devise_for :accounts
  match '/accounts/my', to: "accounts#my"


  resources :players

  root to: "accounts#my"
end
