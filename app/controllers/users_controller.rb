class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def index
    @user = User.new
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    if params[:created_at] == ""
       @search_book = "日付を選択してください"

    else
       create_at = params[:created_at]
       @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count

    end

    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week

    @six_day_book = @books.created_6days
    @five_day_book = @books.created_5days
    @four_day_book = @books.created_4days
    @three_day_book = @books.created_3days
    @two_day_book = @books.created_2days

    @books = @user.books.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size }

  end

  def edit
    @user = User.find(params[:id])
    redirect_to user_path(current_user.id) unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email, :password, :password_confirmation, :title)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end