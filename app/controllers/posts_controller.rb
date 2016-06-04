class PostsController < ApplicationController
  before_action :require_user!, only: [:create, :new, :edit, :update]

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      flash[:notice] = "Posted!"
      redirect_to post_url(@post)
    else
      flash.now[:notice] = "Didn't save"
      render :new
    end
  end

  def new
    @post = Post.new
    @subs = Sub.all
    render :new
  end

  def show
    @post = Post.find(params[:id])
    @author = User.find(@post.author_id)
    render :show
  end

  def destroy
  end

  def update
    @post = Post.new(post_params)
    @post.update_attributes(post_params)
    if @post.save
      flash[:notice] = "Edited!"
      redirect_to post_url(@post)
    else
      flash.now[:notice] = "Didn't save"
      render :edit
    end
  end

  def edit
    @post = Post.find(params[:id])
    @subs = Sub.all
    render :edit
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
end
