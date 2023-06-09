class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q, only: [:index]

  def index
    @spots = @q.result.with_attached_spot_image.includes(:categories, :spot_category_relations).page(params[:page]).per(12).order(created_at: :desc)
    @categories = Category.all
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @spots = @category.spots.page(params[:page]).per(12).order(created_at: :desc)
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    if @spot.save
      flash[:notice] = "#{@spot.user.name}さんのスポット投稿が完了しました。"
      redirect_to spots_path
    else
      render "new"
    end
  end

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update(spot_params)
      flash[:notice] = "#{@spot.user.name}さんの投稿を更新しました"
      redirect_to spots_path
    else
      render "edit"
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
    redirect_to spots_path
    flash[:notice] = "#{@spot.user.name}さんの投稿を削除しました"
  end

  private

  def spot_params
    params.require(:spot).permit(:title, :content, :address, :latitude, :longitude, :spot_image, :user_id, category_ids: [])
  end

  def set_q
    @q = Spot.ransack(params[:q])
  end
end
