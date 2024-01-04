class ChangeTrxIdToUniqueness < ActiveRecord::Migration[7.0]
  def change
    add_index :user_rewards, [:trx_id], unique: true
  end
end
