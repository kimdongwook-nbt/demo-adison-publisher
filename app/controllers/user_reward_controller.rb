class UserRewardController < ApplicationController
  def index
    conditions = search_params
    @user_rewards = UserReward.retrieve_by(conditions[:trx_id], conditions[:click_key], conditions[:uid_hash], conditions[:ad_title], conditions[:country])
  end

  def search_params
    params.permit(:trx_id, :click_key, :uid_hash, :ad_title, :country)
  end
end
