Rails.application.routes.draw do
  
  resources :backups

  resources :photos

  resources :browsers

  resources :sms_messages

  resources :apps

  resources :calls

  resources :contacts

  resources :locations
  
  scope '/import' do
    post 'sms', to: 'sms_messages#import', :defaults => { :format => 'json' }
    post 'browsers', to: 'browsers#import', :defaults => { :format => 'json' }
    post 'appsummary', to: 'apps#import_summary', :defaults => { :format => 'json' }
    post 'calls', to: 'calls#import', :defaults => { :format => 'json' }
    post 'locations', to: 'locations#import', :defaults => { :format => 'json' }
    post 'photos', to: 'photos#import', :defaults => { :format => 'json' }
    

    # get 'backup/:filepath', to: 'backups#import', :defaults => { :format => 'json' }

    # Not Used.

    # get 'contacts/:filepath', to: 'contacts#import', :defaults => { :format => 'json' }
    # get 'apps/:filepath', to: 'apps#import', :defaults => { :format => 'json' }

  end
  
  scope '/system' do
    get 'ping', to: 'apps#ping', :defaults => { :format => 'json' }
  end

end
  