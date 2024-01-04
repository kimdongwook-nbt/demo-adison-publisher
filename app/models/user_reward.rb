class UserReward < ApplicationRecord
  belongs_to :user

  validates :trx_id, :click_key, :uid_hash, :advertising_id, :client_platform_type, :campaign_id,
            :ad_id, :event_code, :ad_title, :reward, :language, :country, :issued_key, :issued_reward_at,
            presence: true
  validates :trx_id, uniqueness: true
  validates :click_key, uniqueness: { scope: :event_code, message: 'click_key and event_code must be unique' }

  class << self
    def retrieve_by(trx_id, click_key, uid_hash, ad_title, country)
      query = UserReward.order(id: :desc)
      query = query.where("trx_id like ?", "%#{trx_id}%") if trx_id.present?
      query = query.where("click_key like ?", "%#{click_key}%") if click_key.present?
      query = query.where("uid_hash like ?", "%#{uid_hash}%") if uid_hash.present?
      query = query.where("ad_title like ?", "%#{ad_title}%") if ad_title.present?
      query = query.where("country like ?", "%#{country}%") if country.present?
      query.all
    end
  end
end
