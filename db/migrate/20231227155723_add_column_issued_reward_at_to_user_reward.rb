class AddColumnIssuedRewardAtToUserReward < ActiveRecord::Migration[7.0]
  def change
    add_column :user_rewards, :issued_reward_at, :datetime
  end
end
