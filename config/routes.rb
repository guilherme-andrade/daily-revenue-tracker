Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users
  resources :daily_reports, only: [:new, :create, :show, :destroy]
  patch 'daily_reports/:id/confirm', to: 'daily_reports#confirm', as: 'confirm_daily_report'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
