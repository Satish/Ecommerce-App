ActionController::Routing::Routes.draw do |map|

  map.resources :orders, :collection => { :get_state_options => :post }

  # Normal Routes
  map.root :controller => "products"
  map.resources :users
  map.resources :products, :only => [:index]
  map.with_options :controller => 'products' do |controller|
    controller.update_select_options '/products/update_select_options/:id', :action => 'update_select_options'
    controller.product '/products/:permalink', :action => 'show'
#    controller.product '/products/:tag', :action => 'index'
  end

  map.resource :cart, :except => [:new, :edit], :collection => { :update_item => :put }
  map.resources :categories, :only => [:index]
  map.resources :brands, :only => [:index]
  map.resources :pages, :only => [:index]
  map.resources :posts, :only => [] do |post|
    post.resources :comments, :only => [:create]
  end
  
  map.category '/categories/:permalink', :controller => 'categories', :action => 'show'
  map.brand '/brands/:permalink', :controller => 'brands', :action => 'show'
  map.page '/pages/:permalink', :controller => 'pages', :action => 'show'
  map.with_options :controller => 'posts' do |controller|
    controller.posts '/blog', :action => "index"
    controller.archives '/blog/archives', :action => "archives"
    controller.feed '/feed', :action => "feed"
#    controller.connect ':year/:month/:day/:permalink', :action => 'show', :requirements => { :year => /\d+/ }
    controller.post '/blog/:permalink', :action => 'show'
  end

  map.with_options :controller => 'users' do |user|
    user.signup '/signup', :action => 'new'
    user.register '/register', :action => 'create'
    user.activate '/activate/:activation_code', :action => 'activate', :activation_code => nil
  end
  
  map.resources :sessions, :only => [:create]
  map.with_options :controller => 'sessions' do |session|
    session.login  '/login', :action => 'new'
    session.logout '/logout', :action => 'destroy'
  end
  
 
  # Admin Routes (under admin namescope)
  map.namespace :admin do |admin|
    admin.root :controller => 'dashboard'
    admin.resource :stores, :only => [:show, :edit, :update], :as => :store
    admin.resources :dashboard, :only => [:index]
    admin.resources :categories, :member => {:products => :get, :add_products => [:get, :put], :remove_products => :put}
    admin.resources :brands, :member => {:products => :get}
    admin.resources :products, :has_many => [:skus]
    admin.resources :product_attributes, :except => [:show]
    admin.resources :images, :only => [:index, :destroy]
    admin.resources :pages
    admin.resource :blog, :only => [:show, :edit, :update]
    admin.resources :posts, :has_many => [:comments]
    admin.resources :tiny_mce_photos, :only => [:index, :create]
    admin.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }
    admin.resources :shipping_methods
    admin.resources :currencies
    admin.resource :mail_settings, :only => [:show, :edit, :update]

#    admin.with_options :controller => 'users' do |user|
#      user.signup '/signup', :action => 'new'
#      user.register '/register', :action => 'create'
#      user.activate '/activate/:activation_code', :action => 'activate', :activation_code => nil
#    end

  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
