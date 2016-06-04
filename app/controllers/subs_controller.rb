class SubsController < ApplicationController
  before_action :require_user!, only: [:new, :create, :edit, :update]
  before_action :require_moderator, only: [:edit, :update]

  def require_moderator
    unless current_user.owns_sub(params[:id])
      flash[:notice] = "Must be moderator to edit sub"
      redirect_to subs_url
    end
  end

  def index
    @subs = Sub.all
    render :index
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id

    if @sub.save
      flash[:notice] = "Sub was saved!"
      redirect_to sub_url(@sub)
    else
      flash.now[:notice] = "Sub was not saved"
      render :new
    end
  end

  def new
    @sub = Sub.new
    render :new
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def update
    @sub = Sub.find(params[:id])
    @sub.update_attributes(sub_params)

    if @sub.save
      redirect_to sub_url(@sub)
    else
      render :edit
    end
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
