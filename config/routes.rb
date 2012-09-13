ActionController::Routing::Routes.draw do |map|
  
  # System routes
  map.resource :user_session, :only => [:new, :create, :destroy]
  map.resources :listings, :member => {:sold => :put}
  map.resources :users, :only => [:new, :edit, :show, :update, :create], :member => {:recommend => :post}, :collection => {:welcome => :get}
  # map.resource :account, :member => {:send_password_reset_instructions => :post, :forgot_password => :get, :reset_password_confirmation => :get, :reset_password => :post}
  map.resources :messages, :collection => {:post => :get, :reply => :get}
  map.resources :article_categories, :has_many => :articles
  map.resources :contacts
  
  # JSON  
  map.connect "/json", :controller => "json"
  
  # RSS Routes
  map.connect 'all.xml', :controller => 'listings', :action => 'all_xml'  
  map.connect 'sell.xml', :controller => 'listings', :action => 'all_sell'  
  map.connect 'buy.xml', :controller => 'listings', :action => 'all_buy'  
  
  
  # Admin section  
  map.admin_dashboard '/admin', :controller => 'admin/home'
  map.namespace :admin do |admin|
    admin.resources :users, :member => {:activate => :put, :deactivate => :put} do |users|
      users.resources :contacts
    end
    admin.resources :product_categories
    admin.resources :measuring_systems
    admin.resources :products
    admin.resources :listing_types
    admin.resources :listings
    admin.resources :settings
    admin.resources :messages
    admin.resources :pages
    admin.resources :article_categories
    admin.resources :articles
    admin.resources :reports
  end
  
  # TEST ROUTES
  #map.test_console '/test_console', :controller => 'test_console', :action => 'index'  
  
  # STATIC AND NAMED ROUTES
  map.root :controller => 'home'
  map.sell_home '/index2', :controller => 'home', :action => 'index2'
  
  # MISC
  map.sell '/for-sale', :controller => "listings", :action => "sell"
  map.buy '/buying-requests', :controller => "listings", :action => "buy"
  map.search '/search', :controller => "search"
  
  # ARTICLES
  map.about_us '/about-us/:id', :controller => "articles", :action => "about_us"
  map.help '/help/:id', :controller => "articles", :action => "help"
  map.contact_us '/contact-us', :controller => "contact_us"
  map.links '/links/:id', :controller => "articles", :action => "links"
  map.privacy_policy '/privacy-policy/:id', :controller => "articles", :action => "privacy_policy"
  map.terms_and_conditions '/terms-and-conditions/:id', :controller => "articles", :action => "terms_and_conditions"
    

  # DEFAULT  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'  

  # 404 Route
  map.error ':controllername', :controller => 'home', :action => '404'

end
