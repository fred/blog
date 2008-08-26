ActionController::Routing::Routes.draw do |map|
    
  map.resources :comments
  map.resources :articles
  map.resources :users
  map.resources :categories
  map.resources :tags
  map.resource :session
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  

  # allow neat perma urls
  # map.connect 'articles/:permalink',
  #   :controller => 'articles', :action => 'show'

  # allow neat tagged urls
  map.connect 'articles/tag/:tag',
    :controller => 'articles', :action => 'index'
        
  # allow neat permalinked urls
  map.connect 'articles/page/:page',
    :controller => 'articles', :action => 'index',
    :page => /\d+/

  date_options = { :year => /\d{4}/, :month => /(?:0?[1-9]|1[12])/, :day => /\d{1,2}/ }
  
  map.with_options(:conditions => {:method => :get}) do |get|
    get.with_options(date_options.merge(:controller => 'articles')) do |dated|
      dated.with_options(:action => 'index') do |finder|
        # new URL
        finder.connect ':year/page/:page',
          :month => nil, :day => nil, :page => /\d+/
        finder.connect ':year/:month/page/:page',
          :day => nil, :page => /\d+/
        finder.connect ':year/:month/:day/page/:page', 
          :page => /\d+/
        finder.connect ':year',
          :month => nil, :day => nil
        finder.connect ':year/:month',
          :day => nil
        finder.connect ':year/:month/:day', 
          :page => nil
      end
      dated.with_options(:action => 'show') do |finder|
        finder.connect ':year/:month/:day/:permalink'
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
     map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
       admin.resources :users
       admin.resources :settings
       admin.resources :articles
       admin.resources :comments
       admin.resources :tags
     end

  map.connect "/admin", :controller => "admin/dashboard"
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "articles"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
