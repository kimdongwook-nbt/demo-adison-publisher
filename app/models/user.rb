class User < ApplicationRecord
  resourcify
  has_many :user_rewards, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 30 }

  class << self
    def retrieve_by(email, name, hash)
      query = User.order(id: :desc)
      query = query.where("email like ?", "%#{email}%") if email.present?
      query = query.where("name like ?", "%#{name}%") if name.present?
      query = query.where("uid_hash like ?", "%#{hash}%") if hash.present?
      query.all
    end

    def find_by_id_with_rewards(id)
      User.includes(:user_rewards)
          .find_by(id: id)
    end
  end

  def add_reward(reward)
    self.reward += reward.to_i
    self.updated_at = Time.zone.now
  end
end
