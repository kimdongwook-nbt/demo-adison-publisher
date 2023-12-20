class CreateUserRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_rewards do |t|
      t.string :trx_id, null: false
      t.string :click_key, null: false
      t.string :uid_hash, null: false
      t.string :advertising_id, null: false
      t.integer :client_platform_type, null: false
      t.integer :campaign_id, null: false
      t.integer :ad_id, null: false
      t.string :event_code, null: false
      t.string :ad_title, null: false
      t.string :event_title
      t.integer :reward, null: false
      t.string :language, null: false
      t.string :country, null: false
      t.timestamps

      t.references :user, null: false, foreign_key: true
    end
  end
end
