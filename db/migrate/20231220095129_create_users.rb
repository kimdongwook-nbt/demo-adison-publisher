class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, unique: true, null: false
      t.string :name, limit: 30
      t.string :uid
      t.string :uid_hash
      t.integer :reward, null: false, default: 0
      t.timestamps
    end
  end
end
