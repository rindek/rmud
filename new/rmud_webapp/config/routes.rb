RmudWebapp::Application.routes.draw do
  devise_for :accounts

  root to: "home#index"
end
