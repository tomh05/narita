Rails.application.routes.draw do
  resources :browsers

  resources :sms_messages

  resources :apps

  resources :calls

  resources :contacts

  resources :locations
  
  scope '/import' do
    get 'contacts', to: 'contacts#import', :defaults => { :format => 'json' }
    get 'calls', to: 'calls#import', :defaults => { :format => 'json' }
    get 'apps', to: 'apps#import', :defaults => { :format => 'json' }
    get 'sms', to: 'sms_messages#import', :defaults => { :format => 'json' }
    get 'locations', to: 'locations#import', :defaults => { :format => 'json' }
    get 'browsers', to: 'browsers#import', :defaults => { :format => 'json' }
  end

end
  