class UsersController < ApplicationController
  
  before_action :check_login
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_users = User.active.by_role.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_users = User.inactive.by_role.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "#{@user.username} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "#{@user.username} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: "The user was removed from the system."
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:id, :username, :password, :password_confirmation, :role, :active)
  end

end