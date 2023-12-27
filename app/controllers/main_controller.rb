class MainController < ApplicationController
  before_action :authenticate_admin!

  def index
    @admins = Admin.search_by_email(search_params[:email])
  end

  private

  def search_params
    params.permit(:email)
  end
end
