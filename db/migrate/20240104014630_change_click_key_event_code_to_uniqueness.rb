class ChangeClickKeyEventCodeToUniqueness < ActiveRecord::Migration[7.0]
  def change
    add_index :user_rewards, [:click_key, :event_code], unique: true
  end
end
