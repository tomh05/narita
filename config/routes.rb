Rails.application.routes.draw do
  resources :calls

  resources :contacts

  resources :locations
  
  scope '/import' do
    get 'locations', to: 'locations#import', :defaults => { :format => 'json' }
    get 'contacts', to: 'contacts#import', :defaults => { :format => 'json' }
    get 'calls', to: 'calls#import', :defaults => { :format => 'json' }
  end

end
