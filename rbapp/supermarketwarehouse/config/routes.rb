Rails.application.routes.draw do
  get 'stock_availability/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'stock_availability#index'
end
