# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0e4ea5baa8c0a12246cf5626bc45de32'
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  layout 'sleek'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  before_filter :set_current_user
  
  before_filter :load_tags
  
  def load_tags
    @tags = Tag.find(:all, :include => :taggings)
  end
  
  def set_current_user
    if logged_in?
      User.current_user = current_user
    end
  end
  
  def auto_discovery_defaults
    auto_discovery_feed
  end

  def auto_discovery_feed(options = { })
    with_options(options.reverse_merge(:only_path => true)) do |opts|
      @auto_discovery_url_rss = opts.url_for(:format => 'rss')
      @auto_discovery_url_atom = opts.url_for(:format => 'atom')
    end
  end

  
  # Control whether caching occurs for an action at runtime instead of load time.  
  # To control caching, add a method *cache_action?(action_name)* to your controller.  
  # If this method returns true, then the action cache will work as before.  
  # If false, then caching will not occur for this request.  
  def cache_action?(action_name)
 	  !admin?
 	end
 	
 	def admin?
 	  logged_in && current_user.admin
  end
  
end
