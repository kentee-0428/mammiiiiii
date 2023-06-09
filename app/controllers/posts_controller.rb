class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q, only: [:index]

  def index
    @results = @q.result.with_attached_post_image.includes(:likes, :user, :comments).page(params[:page]).per(15).order(created_at: :desc)
  end

  def show
    @post = Post.preload(:likes, :user, :comments).find(params[:id])
    @likes = @post.likes
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "#{@post.user.name}さんの投稿が完了しました。"
      redirect_to posts_path
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "#{@post.user.name}さんの投稿を更新しました"
      redirect_to posts_path
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
    flash[:notice] = "#{@post.user.name}さんの投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:content, :user_id, :post_image)
  end

  def set_q
    @q = Post.ransack(params[:q])
  end

end
