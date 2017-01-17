Rails.application.routes.draw do
  get 'appointment/index'
  get '/redirect', to: 'appointment#redirect', as: 'redirect'
  get '/callback', to: 'appointment#callback', as: 'callback'
  get '/calendars', to: 'appointment#calendars', as: 'calendars'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'appointment#index'
end
