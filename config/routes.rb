# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'users/sessions',
                            unlocks: 'users/unlocks',
                            registerations: 'users/registerations',
                            passwords: 'users/passwords',
                            omniauth: 'users/omniauth',
                            confirmations: 'users/confirmations',
                            omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, except: :create do
    delete 'bulk_destroy/:ids', to: 'users#bulk_destroy', on: :collection
    patch 'bulk_update/:ids', to: 'users#bulk_update', on: :collection
  end
  resources :users, only: :create, as: :create, path: :admin_create
  authenticated :user, -> (u) { u.has_role?(:super_user) } do
    root to: 'users#index', as: :super_user_root
  end
  authenticated :user, -> (u) { u.has_role?(:evaluator) } do
    root to: 'evaluations#index', as: :evaluator_root
  end
  resources :roles
  resources :groups, except: :show
  resources :categories

  resources :sections do
    collection do
      get :filter
    end
  end
  resources :enrollments do
    collection do
      get :filter
    end
  end
  resources :tasks do
    collection do
      get :filter
    end
  end

  resources :evaluations do
    collection do
      get :filter
    end
  end

  resources :preferences, only: %i[index update]
  resources :courses do
    collection do
      get :filter
    end
  end

  resources :status_transition_histories, only: :index
  resources :syncs
  resources :notifications, only: [] do
    collection do
      patch :read
    end
  end
  resources :events, only: [:create] do
    collection do
      get :watch
      post :synchronize
    end
  end
  root to: 'roles#index', as: :non_super_user_root
end
