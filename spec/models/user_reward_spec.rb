# frozen_string_literal: true
require "rails_helper"

RSpec.describe UserReward, type: :model do
  before(:example) do
    @user = User.create(
      email: "user@mail.com",
      name: "user",
      uid_hash: "test_uid_hash",
      reward: 0
    )

    @user_reward = UserReward.create(
      trx_id: 'test_trx_id',
      click_key: "test_click_key",
      uid_hash: "test_uid_hash",
      advertising_id: "test_advertising_id",
      client_platform_type: 1,
      campaign_id: 1,
      ad_id: 1,
      event_code: "__default__",
      ad_title: "ad_title",
      event_title: nil,
      reward: 10,
      language: "en",
      country: "US",
      issued_key: "test_issued_key",
      issued_reward_at: Time.now,
      user_id: @user.id
    )
  end

  describe "유효성 검사 테스트" do
    it "trx_id 는 중복될 수 없다." do
      given_trx_id = "test_trx_id"

      user_reward = UserReward.new(
        trx_id: given_trx_id,
        click_key: "other_test_click_key",
        uid_hash: "test_uid_hash",
        advertising_id: "test_advertising_id",
        client_platform_type: 1,
        campaign_id: 1,
        ad_id: 1,
        event_code: "__default__",
        ad_title: "ad_title",
        event_title: nil,
        reward: 10,
        language: "en",
        country: "US",
        issued_key: "test_issued_key",
        issued_reward_at: Time.now,
        user_id: @user.id
      )

      expect(user_reward.save).to eq false
      expect(user_reward.errors.full_messages_for(:trx_id)).to end_with("Trx has already been taken")
    end

    it "click_key & event_code 는 중복될 수 없다." do
      given_click_key = 'test_click_key'
      given_event_code = '__default__'

      user_reward = UserReward.new(
        trx_id: 'test_trx_id',
        click_key: given_click_key,
        uid_hash: "test_uid_hash",
        advertising_id: "test_advertising_id",
        client_platform_type: 1,
        campaign_id: 1,
        ad_id: 1,
        event_code: given_event_code,
        ad_title: "ad_title",
        event_title: nil,
        reward: 10,
        language: "en",
        country: "US",
        issued_key: "test_issued_key",
        issued_reward_at: Time.now,
        user_id: @user.id
      )

      expect(user_reward.save).to eq false
      expect(user_reward.errors.full_messages).to end_with('Click key click_key and event_code must be unique')
    end
  end
end
