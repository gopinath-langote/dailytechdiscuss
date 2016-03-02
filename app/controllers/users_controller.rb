class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    if current_user.admin
      if params[:type]
        @type= params[:type]
        if(@type == "Admin")
          @users = User.where(:admin => true)
        end
        if(@type == "Non Admin")
          @users = User.where(:admin => false)
        end
        if(@type =="All")
          @users = User.paginate(page: params[:page])
        end
      else
        if params[:search]
          @query= params[:search]
          @users = User.where("name like ?", "%#{@query}%")
          # @users = User.search(params[:search]).order("created_at DESC")
        else
          @users = User.paginate(page: params[:page])
        end
      end
    else
      redirect_to user_path(current_user)
      flash[:failure] = "You are not Admin!!!"
    end
  end

  # It returns the articles whose titles contain one or more words that form the query
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("title like ?", "%#{query}%")
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def makeadmin
    flash[:success] = "making admin!"
    @user=User.find(params[:id])
    @user.admin=true
    @user.save
    redirect_to users_url
  end

  def makenonadmin
    flash[:success] = "making non admin!"
    @user=User.find(params[:id])
    @user.admin=false
    @user.save
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  ########################################################
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


end
