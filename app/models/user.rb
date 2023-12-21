class User < ApplicationRecord
  has_many :user_rewards

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 30 }
end
