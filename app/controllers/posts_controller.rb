class PostsController < ApplicationController

  # GET /discussions/1/posts
  # GET /discussions/1/posts.xml
  def index
    @discussion_posts = DiscussionPost.find_all_by_discussion_id(params[:discussion_id])

    respond_to do |format|
      format.html # index.html.erb
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

    # verifica se o post é do usuário
    if DiscussionPost.find(post_id).user_id == current_user.id
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

end
