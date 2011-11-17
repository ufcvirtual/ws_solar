class PostsController < ApplicationController

  before_filter :authenticate_user!

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

  # POST /posts
  # POST /posts.xml
  def create
    @discussion_post = DiscussionPost.new(params[:discussion_post])

    respond_to do |format|
      if @discussion_post.save
        format.html { redirect_to(discussion_post_path(Discussion.find(params[:discussion_id]), @discussion_post), :notice => 'Discussion post was successfully created.') }
        format.xml  { render :xml => @discussion_post, :status => :created, :location => @discussion_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @discussion_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @discussion_post = DiscussionPost.find(params[:id])

    respond_to do |format|
      if @discussion_post.update_attributes(params[:discussion_post])
        format.html { redirect_to(@discussion_post, :notice => 'Discussion post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @discussion_post.errors, :status => :unprocessable_entity }
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
end
