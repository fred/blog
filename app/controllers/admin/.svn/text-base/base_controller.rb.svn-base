class Admin::BaseController < ApplicationController
  
  before_filter :login_required
  before_filter :load_tags
  
  layout 'admin'
  
  def load_tags
    @tags = Tag.find(:all, :include => :taggings)
  end
    
end
