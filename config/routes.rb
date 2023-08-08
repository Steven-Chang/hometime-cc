# frozen_string_literal: true

Rails.application.routes.draw do
  resources :reservations, actions: nil, defaults: { format: 'json' } do
    post 'create_or_update', on: :collection
  end
end
