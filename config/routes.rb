Rails.application.routes.draw do

  resources :people

  resources :app_names

  get 'interactions'  , to: 'interactions#index'

  devise_for :users

  resources :facebook_messages

  resources :sims

  resources :screens

  resources :app_uniques

  resources :appnames

  resources :backups

  resources :photos

  resources :browsers

  resources :sms_messages

  resources :apps

  resources :calls

  resources :contacts

  resources :locations

  root to: "apps#index"

  scope '/import' do
    post 'sms', to: 'sms_messages#import', :defaults => { :format => 'json' }
    post 'browsers', to: 'browsers#import', :defaults => { :format => 'json' }
    post 'appsummary', to: 'apps#import', :defaults => { :format => 'json' }
    post 'appunique', to: 'app_uniques#import', :defaults => { :format => 'json' }
    post 'calls', to: 'calls#import', :defaults => { :format => 'json' }
    post 'locations', to: 'locations#import', :defaults => { :format => 'json' }
    post 'photos', to: 'photos#import', :defaults => { :format => 'json' }
    post 'backup', to: 'backups#import', :defaults => { :format => 'json' }
    post 'screen', to: 'screens#import', :defaults => { :format => 'json' }
    post 'sim', to: 'sims#import', :defaults => { :format => 'json' }
    post 'facebook', to: 'facebook_messages#import', :defaults => { :format => 'json' }
  end

  scope '/system' do
    get 'ping', to: 'welcome#ping', :defaults => { :format => 'json' }
  end

end
