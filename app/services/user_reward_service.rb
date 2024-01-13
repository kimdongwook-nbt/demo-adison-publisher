# frozen_string_literal: true

class UserRewardService
  def pay_reward_to_user(trx_id: , click_key: , uid: , advertising_id: , client_platform_type:, campaign_id:, ad_id:, event_code:, ad_title:, reward:, language:, country:, event_title: "")
    user = User.find_by(uid_hash: uid)

    raise PubErrors::InvalidUid.new if user.blank?

    user_reward = create_user_reward(user:, trx_id:, click_key:, uid:, advertising_id:, client_platform_type:, campaign_id:, ad_id:, event_code:, ad_title:, reward:, language:, country:, event_title:)
    user_reward.validate

    raise PubErrors::DuplicatedRequest.new if duplicated_request?(user_reward)
    raise PubErrors::BadRequest.new if reward_less_than_equal_0?(user_reward)
    raise PubErrors::BadRequest.new unless valid_client_platform_type?(user_reward)

    User.transaction do
      user.add_reward(reward)
      user.user_rewards.create(user_reward.attributes)
      user.save
    end

    user_reward.issued_key
  end

  private

  def create_user_reward(user: , trx_id: , click_key: , uid: , advertising_id: , client_platform_type: , campaign_id:, ad_id: , event_code: , ad_title: , reward: , language: , country: , event_title: "")
    UserReward.new(
      trx_id:,
      click_key:,
      uid_hash: uid,
      advertising_id:,
      client_platform_type:,
      campaign_id: campaign_id.to_i,
      ad_id: ad_id.to_i,
      event_code:,
      ad_title:,
      event_title:,
      reward: reward.to_i,
      language:,
      country:,
      issued_key: SecureRandom.uuid,
      issued_reward_at: Time.zone.now,
      user_id: user.id
    )
  end

  def duplicated_request?(user_reward)
    return true if user_reward.errors.full_messages_for(:trx_id).present?
    return true if user_reward.errors.full_messages_for(:click_key).present?

    false
  end

  def reward_less_than_equal_0?(user_reward)
    return true if user_reward.reward.to_i <= 0

    false
  end

  def valid_client_platform_type?(user_reward)
    return false unless [
      ClientPlatformType::ANDROID,
      ClientPlatformType::IOS
    ].include?(user_reward.client_platform_type)

    true
  end
end
