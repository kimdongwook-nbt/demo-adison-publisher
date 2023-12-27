class AddColumnIssuedKeyToUserReward < ActiveRecord::Migration[7.0]
  def change
    add_column :user_rewards, :issued_key, :string, unique: true
  end
end
