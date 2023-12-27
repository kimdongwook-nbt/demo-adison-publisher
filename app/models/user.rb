class User < ApplicationRecord
  resourcify
  has_many :user_rewards, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 30 }

  def add_reward(reward)
    self.reward += reward.to_i
    self.updated_at = Time.now
  end
end
