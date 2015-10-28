Rails.application.routes.draw do
  resources :contacts

  resources :locations
  
  scope '/import' do
    get 'locations', to: 'locations#import', :defaults => { :format => 'json' }
  end

end
