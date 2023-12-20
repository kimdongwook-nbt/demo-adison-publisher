class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :email, unique: true, null: false
      t.string :encrypted_password, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
