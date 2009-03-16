ActionController::Routing::Routes.draw do |map|
  
  # Normal(Public) Routes
  map.resources :users
  map.with_options :controller => 'users' do |user|
    user.signup '/signup', :action => 'new'
    user.register '/register', :action => 'create'
    user.activate '/activate/:activation_code', :action => 'activate', :activation_code => nil
  end
  
  map.resources :sessions
  map.with_options :controller => 'sessions' do |session|
    session.login  '/login', :action => 'new'
    session.logout '/logout', :action => 'destroy'
  end
  
 
  # Admin Routes (under admin namescope)
  map.namespace :admin do |admin|
    admin.root :controller => 'dashboard'
    admin.resources :dashboard, :only => [:index]
    admin.resources :pages
    admin.resources :posts
    admin.resources :comments
    admin.resources :tiny_mce_photos, :only => [:index, :create]
    admin.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }
    
    admin.with_options :controller => 'users' do |user|
      user.signup '/signup', :action => 'new'
      user.register '/register', :action => 'create'
      user.activate '/activate/:activation_code', :action => 'activate', :activation_code => nil
    end
    
    admin.resources :sessions
    admin.with_options :controller => 'sessions' do |session|
      session.login  '/login', :action => 'new'
      session.logout '/logout', :action => 'destroy'
    end
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
