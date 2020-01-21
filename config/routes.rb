Rails.application.routes.draw do
  mount UserImpersonate::Engine => '/impersonate', as: 'impersonate_engine'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations', invitations: 'users/invitations' }, skip: [:registrations]
  devise_scope :user do
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
  end

  root to: 'landings#index'

  get 'profile' => 'users#show'

  resource :stats, only: [:show] do
    collection do
      get :users
      get :activity
      get :cohorts

      get :tables
    end
  end

  get 'qui_sommes_nous', to: 'about#qui_sommes_nous'
  get 'cgu', to: 'about#cgu'
  get 'top_5', to: 'about#top_5'

  get 'entreprise/:slug', to: 'landings#show', as: 'landing'
  get 'aide/:slug', to: 'landings#show', as: 'featured_landing'

  resource :solicitation, only: %i[create]

  resources :diagnoses, only: %i[index new show], path: 'analyses' do
    collection do
      get :archives
      get :index_antenne
      get :archives_antenne
      post :create_diagnosis_without_siret
      get :find_cities
    end

    member do
      post :archive
      post :unarchive

      get :besoins, action: :step2
      post :besoins
      get :visite, action: :step3
      post :visite
      get :selection, action: :step4
      post :selection
    end
  end

  resources :companies, only: %i[show], param: :siret do
    collection do
      get :search
      post :create_diagnosis_from_siret
    end
  end

  resources :besoins, as: 'needs', controller: 'needs', only: %i[index show] do
    collection do
      get :archives
      get :index_antenne
      get :archives_antenne
    end
    member do
      get :additional_experts
      post :add_match
    end
  end

  resources :matches, only: %i[update]

  resources :feedbacks, only: %i[create destroy]

  resources :relances, as: 'reminders', controller: 'reminders', only: %i[index show] do
    member do
      post :reminders_notes
    end
  end

  resources :experts, only: %i[edit update]

  get '/diagnoses', to: redirect('/analyses')
end
