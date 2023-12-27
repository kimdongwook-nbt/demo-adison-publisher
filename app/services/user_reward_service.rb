# frozen_string_literal: true

class UserRewardService

  def pay_reward_to_user(trx_id, click_key, uid, advertising_id, client_platform_type, campaign_id, ad_id, event_code, ad_title, event_title = "", reward, language, country)
    user = User.find_by_uid_hash(uid)

    raise PubErrors::InvalidUid.new unless user.present?
    raise PubErrors::DuplicatedTrxId.new if user.user_rewards.where(trx_id: trx_id).any?

    user.add_reward(reward)
    user.save

    issued_key = SecureRandom.uuid
    user.user_rewards.create(
      trx_id: trx_id,
      click_key: click_key,
      uid_hash: uid,
      advertising_id: advertising_id,
      client_platform_type: client_platform_type,
      campaign_id: campaign_id.to_i,
      ad_id: ad_id.to_i,
      event_code: event_code,
      ad_title: ad_title,
      event_title: event_title,
      reward: reward.to_i,
      language: language,
      country: country,
      issued_key: issued_key,
      issued_reward_at: Time.zone.now
    )

    issued_key
  end

end

