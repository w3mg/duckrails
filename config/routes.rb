require 'duckrails/router'

Rails.application.routes.draw do
  root 'duckrails/home#index'

  namespace 'duckrails' do
    resources :mocks
  end

  Duckrails::Router.load_mock_routes!
end
