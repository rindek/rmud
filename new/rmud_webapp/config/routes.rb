RmudWebapp::Application.routes.draw do
  devise_for :accounts
  match '/accounts/my', to: "accounts#my"

  root to: "accounts#my"
end
