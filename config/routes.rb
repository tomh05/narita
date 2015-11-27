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


    # post 'browsers', to: 'browsers#import', :defaults => { :format => 'json' }
    # post 'appsummary/:filepath', to: 'apps#import_summary', :defaults => { :format => 'json' }
    # get 'calls/:filepath', to: 'calls#import', :defaults => { :format => 'json' }
    # get 'locations/:filepath', to: 'locations#import', :defaults => { :format => 'json' }
    # get 'browsers/:filepath', to: 'browsers#import', :defaults => { :format => 'json' }
    # get 'sms/:filepath', to: 'sms_messages#import', :defaults => { :format => 'json' }
    # get 'photos/:filename/:filetype/:username', to: 'photos#import', :defaults => { :format => 'json' }
    # get 'backup/:filepath', to: 'backups#import', :defaults => { :format => 'json' }

    # Not Used.

    # get 'contacts/:filepath', to: 'contacts#import', :defaults => { :format => 'json' }
    # get 'apps/:filepath', to: 'apps#import', :defaults => { :format => 'json' }

    # To be deleted.
    
    # get 'contacts/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    # get 'calls/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    # get 'locations/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    # get 'apps/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    # get 'sms/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    # get 'browsers/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
  end
  
  scope '/system' do
    get 'ping', to: 'apps#ping', :defaults => { :format => 'json' }
  end

end
  