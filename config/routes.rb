Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users
  resources :daily_reports, only: [:create, :show, :destroy]

  get 'daily_reports/coffee/new', to: 'daily_reports#coffee', as: 'new_coffee_report'
  get 'daily_reports/restaurant/new', to: 'daily_reports#restaurant', as: 'new_restaurant_report'
  get 'daily_reports/store/new', to: 'daily_reports#store', as: 'new_store_report'

  patch 'daily_reports/:id/confirm', to: 'daily_reports#confirm', as: 'confirm_daily_report'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
