class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    conditions = search_params
    @users = User.retrieve_by(conditions[:email], conditions[:name], conditions[:uid_hash])
  end

  def show
    # @user = User.find(params[:id])
    @user = User.find_by_id_with_rewards(params[:id])
  end

  def new
    return redirect_to "/users" unless current_admin.has_super_publisher?

    @user = User.new
  end

  def edit
    return redirect_to "/users" unless current_admin.has_super_publisher?

    @user = User.find(params[:id])
    render json: { error: "Not found", status: 404 } unless @user.present?
  end

  def create
    return render json: { error: "Not Authorized" }, status: :unauthorized unless current_admin.has_super_publisher?

    @user = User.new(user_params)
    @user.uid_hash = SecureRandom.uuid

    if @user.save
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return render json: { error: "Not Authorized" }, status: :unauthorized unless current_admin.has_super_publisher?

    @user = User.find(params[:id])
    if @user.update(user_update_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { error: "Not Authorized" }, status: :unauthorized unless current_admin.has_super_publisher?

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

  def search_params
    params.permit(:email, :name, :uid_hash)
  end
end
