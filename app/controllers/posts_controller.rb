class PostsController < ApplicationController

  before_filter :authenticate_user!

  include ActionView::Helpers::SanitizeHelper

  # GET /discussions/1/posts
  # GET /discussions/1/posts.xml
  def index
    discussions = Discussion.all_by_user(current_user.id)
    @discussion_posts = []

    if discussions.include?(params[:discussion_id].to_i)
      @discussion_posts = DiscussionPost.find_all_by_discussion_id(params[:discussion_id])

      @discussion_posts.collect {|post|
        post.content = sanitize(post.content, :tags => []).strip
      }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @discussion_posts }
      format.json  { render :json => @discussion_posts }
    end
  end

  # GET /discussions/1/posts/20120217111000/news
  def news
    discussions = Discussion.all_by_user(current_user.id)
    @discussion_posts = []

    if discussions.include?(params[:discussion_id].to_i)
      @discussion_posts = DiscussionPost.find_news_by_discussion_id(params[:discussion_id], params[:date].to_time)
      @discussion_posts = sanitize_and_break_posts(@discussion_posts) # Para esta parte do projeto, os caracteres HTML nao devem ser exibidos
    end

    respond_to do |format|
      format.html # news.html.erb
      format.xml  { render :xml => @discussion_posts }
      format.json  { render :json => @discussion_posts }
    end
  end

  # GET /discussions/1/posts/20120217111000/history
  def history
    discussions = Discussion.all_by_user(current_user.id)
    @discussion_posts = []

    if discussions.include?(params[:discussion_id].to_i)
      @discussion_posts = DiscussionPost.find_history_by_discussion_id(params[:discussion_id], params[:date].to_time)
      @discussion_posts = sanitize_and_break_posts(@discussion_posts) # Para esta parte do projeto, os caracteres HTML nao devem ser exibidos
    end

    respond_to do |format|
      format.html # history.html.erb
      format.xml  { render :xml => @discussion_posts }
      format.json  { render :json => @discussion_posts }
    end
  end

  # GET /discussions/1/posts/1
  # GET /discussions/1/posts/1.xml
  def show
    @discussion_post = DiscussionPost.find_by_discussion_id_and_id(params[:discussion_id], params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @discussion_post }
      format.json  { render :json => @discussion_post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @discussion = Discussion.find(params[:discussion_id])
    @discussion_post = DiscussionPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @discussion_post }
    end
  end

  # GET /posts/1/edit
  def edit
    @discussion_post = DiscussionPost.find(params[:id])
  end

  # POST /discussions/:id/posts
  # POST /discussions/:id/posts.xml
  def create
    # parametros necessarios para se criar um post
    params[:discussion_post][:user_id] = current_user.id
    params[:discussion_post][:discussion_id] = params[:discussion_id]
    params[:discussion_post][:profile_id] = Profile.find_by_user_id(current_user.id) # recuperacao de profile temporaria 2012-02-02

    @discussion_post = DiscussionPost.new(params[:discussion_post])

    respond_to do |format|
      if @discussion_post.save
        format.html { redirect_to(discussion_post_path(Discussion.find(params[:discussion_id]), @discussion_post), :notice => 'Discussion post was successfully created.') }
        format.xml  { render :xml => @discussion_post, :status => :created }
        format.json  { render :json => {:result => 1, :post_id => @discussion_post.id}, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @discussion_post.errors, :status => :unprocessable_entity }
        format.json  { render :json => {:result => 0}, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /discussions/:id/posts/1
  # PUT /discussions/:id/posts/1.xml
  def update
    @discussion_post = DiscussionPost.find(params[:id])

    respond_to do |format|
      if @discussion_post.update_attributes(params[:discussion_post])
        format.html { redirect_to(@discussion_post, :notice => 'Discussion post was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @discussion_post.errors, :status => :unprocessable_entity }
        format.json  { render :json => @discussion_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @discussion_post = DiscussionPost.find(params[:id])
    @discussion_post.destroy

    respond_to do |format|
      format.html { redirect_to(discussion_posts_url) }
      format.xml  { head :ok }
    end
  end

  ##
  # Anexa arquivo a um post -- principalmente arquivos de audio
  ##
  def attach_file
    @file = nil
    post_id = params[:id]

    post = DiscussionPost.find(post_id)
    # verifica se o forum ainda esta aberto
    discussion_closed = Discussion.find(post.discussion_id).closed?

    # verifica se o post é do usuário
    if ((not discussion_closed) and (post.user_id == current_user.id))
      attachment = {:attachment => params[:attachment]}
      @file = DiscussionPostFiles.new attachment
      @file.discussion_post_id = post_id
    end

    respond_to do |format|
      if ((not @file.nil?) and @file.save!)
        format.html { render :json => {:result => 1}, :status => :created }
      else
        format.html { render :json => {:result => 0}, :status => :unprocessable_entity }
      end
    end
  end

  private

  ##
  # Tratamento do conteudo dos posts.
  # Retirando caracteres indesejados para esta parte do projeto.
  ##
  def sanitize_and_break_posts(discussion_posts)
    discussion_posts.collect {|post|
      san_post = sanitize(post['content_first'], :tags => []).strip
      post['content_first'] = san_post[0..150] # primeiros caracteres
      post['content_last'] = san_post[151..-1] # parte final
    }
    discussion_posts
  end
end
