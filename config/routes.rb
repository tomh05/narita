Rails.application.routes.draw do
  
  resources :browsers

  resources :sms_messages

  resources :apps

  resources :calls

  resources :contacts

  resources :locations
  
  scope '/import' do
    # get 'contacts/:filepath', to: 'contacts#import', :defaults => { :format => 'json' }
    # get 'calls/:filepath', to: 'calls#import', :defaults => { :format => 'json' }
    # get 'apps/:filepath', to: 'apps#import', :defaults => { :format => 'json' }

    # get 'locations/:filepath', to: 'locations#import', :defaults => { :format => 'json' }
    get 'browsers/:filepath', to: 'browsers#import', :defaults => { :format => 'json' }
    get 'sms/:filepath', to: 'sms_messages#import', :defaults => { :format => 'json' }
    #
    get 'contacts/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    get 'calls/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    get 'apps/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    get 'locations/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }

    # get 'sms/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
    # get 'browsers/:filepath', to: 'apps#ping', :defaults => { :format => 'json' }
  end
  
  scope '/system' do
    get 'ping', to: 'apps#ping', :defaults => { :format => 'json' }
  end

end
  