class ChangeIssuedKeyDatesToNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :user_rewards, :issued_key, false
    change_column_null :user_rewards, :issued_reward_at, false
  end
end
