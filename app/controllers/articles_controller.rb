class ArticlesController < ApplicationController
  
  caches_page :index, :show
  layout "sleek", :except => [:feed, :rss]
  

  # GET /articles
  # GET /articles.xml
  def index
    if params[:tag]
      order = "published_date DESC"
      flash[:notice] = "Articles tagged with <b>#{params[:tag]}</b>"
      @articles = Article.tagged_with(params[:tag].to_s, :on => :tags).paginate(:page => params[:page], 
        :order => order, :per_page => Settings.articles_per_page
      )
    else
      date_options = {}
      date_options.merge!(:date => params.values_at(:year, :month, :day))
      date_options.merge!(:page => params[:page])
      @articles = Article.find_all_by_date(date_options)
    end
    respond_to do |format|
      format.html 
      format.atom
      format.rss
      format.xml
    end
    
  end
  
  # not implemented yet, need to make it use some indexing later.
  def search
    if params[:q]
      @query = params[:q]
    else
      @query = ""
    end
    redirect_to :action => 'index', :tag => @query
  end


  # GET /articles/1
  # GET /articles/1.xml
  def show
    auto_discovery_feed
    if params[:permalink]
      @article = Article.find(:first, :conditions => ["permalink = ?", params[:permalink]])
    else
      @article = Article.find(params[:id])
    end
    @comments = @article.approved_comments
    @comment = Comment.new
    @comment.article_id = @article.id
    
    respond_to do |format|
      format.html 
      format.atom
      format.rss
      format.xml
    end
  end
  
  
  def feed
    @articles = Article.find(:all, 
      :order => 'created_at DESC',
      :conditions => ["articles.published = ?", true],
      :limit => 10
    )
    render :layout => false
  end
  # Build an rss feed
  def rss
    @headers["Content-Type"] = "application/xml"
    @articles = Article.find(:all, 
      :order => 'created_at DESC',
      :conditions => ["articles.published = ?", true],
      :limit => 10
    )
    render :layout => false
  end
  
end
