class Api::Offerwall::OfferwallController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:complete_campaign]

  def complete_campaign
    raise PubErrors::Unauthenticated.new unless validate_hmac_headers
    raise PubErrors::InvalidParameter.new unless validate_required_params

    user_reward_service = UserRewardService.new
    issued_key = user_reward_service.pay_reward_to_user(
      trx_id: params[:trx_id],
      click_key: params[:click_key],
      uid: params[:uid],
      advertising_id: params[:advertising_id],
      client_platform_type: params[:client_platform_type],
      campaign_id: params[:campaign_id],
      ad_id: params[:ad_id],
      event_code: params[:event_code],
      ad_title: params[:ad_title],
      reward: params[:reward],
      language: params[:language],
      country: params[:country],
      event_title: params[:event_title]
    )

    render json: { code: 200, message: 'success', issued_key: }
  rescue PubErrors::Base => e
    Rails.logger.error("유저 리워드 적립 API 예외: #{e.message}")
    render json: { code: e.code, message: e.message }
  end

  private

  def validate_required_params
    required_param_names = %w[trx_id click_key uid advertising_id client_platform_type
                              campaign_id ad_id ad_title reward language country]

    params.each do |key, value|
      return false if required_param_names.include?(key) && !value
    end

    true
  end
end
