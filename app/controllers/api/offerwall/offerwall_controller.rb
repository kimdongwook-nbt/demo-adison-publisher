class Api::Offerwall::OfferwallController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:complete_campaign]
  before_action :authenticate_hmac_headers, only: [:complete_campaign]

  def complete_campaign
    raise PubErrors::Unauthenticated.new unless @valid_hmac
    raise PubErrors::InvalidParameter.new unless validate_required_params

    user_reward_service = UserRewardService.new
    issued_key = user_reward_service.pay_reward_to_user(
      params[:trx_id],
      params[:click_key],
      params[:uid],
      params[:advertising_id],
      params[:client_platform_type],
      params[:campaign_id],
      params[:ad_id],
      params[:event_code],
      params[:ad_title],
      params[:reward],
      params[:language],
      params[:country],
      params[:event_title]
    )

    render json: { code: 200, message: 'success', issued_key: }
  rescue PubErrors::Base => e
    render json: { code: e.code, message: e.message }
  end

  private

  def validate_required_params
    return false unless params[:trx_id]
    return false unless params[:click_key]
    return false unless params[:uid]
    return false unless params[:advertising_id]
    return false unless params[:client_platform_type]
    return false unless params[:campaign_id]
    return false unless params[:ad_id]
    return false unless params[:ad_title]
    return false unless params[:reward]
    return false unless params[:language]
    return false unless params[:country]

    true
  end
end
