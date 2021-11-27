# frozen_string_literal: true

Rails.application.routes.draw do
  resources :rooms, only: [:index]
  resources :meetings, only: %i[index show create update destroy]
end
