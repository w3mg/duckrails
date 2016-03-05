require 'duckrails/router'

Rails.application.routes.draw do
  root 'duckrails/home#index'

  namespace 'duckrails' do
    resources :mocks
  end

  Duckrails::Router.register_mocks
end
