class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    return redirect_to "/users" unless current_admin.has_moderator?

    @user = User.new
  end

  def create
    return render json: { error: "Not Authorized" }, status: 401 unless current_admin.has_moderator?

    @user = User.new(user_params)
    @user.uid_hash = SecureRandom.uuid

    if @user.save
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    return redirect_to "/users" unless current_admin.has_moderator?

    @user = User.find(params[:id])
    render json: { error: "Not found", status: 404 } unless @user.present?
  end

  def update
    return render json: { error: "Not Authorized" }, status: 401 unless current_admin.has_moderator?

    @user = User.find(params[:id])
    if @user.update(user_update_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { error: "Not Authorized" }, status: 401 unless current_admin.has_moderator?

    @user = User.find(params[:id])
    @user.destroy

    redirect_to "/users"
  end

  private

  def user_params
    params.require(:user).permit(:email, :name)
  end

  def user_update_params
    params.require(:user).permit(:name, :reward)
  end
end
