class UserReward < ApplicationRecord
  belongs_to :user

  class << self
    def retrieve_by(trx_id, click_key, uid_hash, ad_title)
      query = UserReward.order(id: :desc)
      query = query.where("trx_id like ?", "%#{trx_id}%") if trx_id.present?
      query = query.where("click_key like ?", "%#{click_key}%") if click_key.present?
      query = query.where("uid_hash like ?", "%#{uid_hash}%") if uid_hash.present?
      query = query.where("ad_title like ?", "%#{ad_title}%") if ad_title.present?
      query.all
    end
  end
end
