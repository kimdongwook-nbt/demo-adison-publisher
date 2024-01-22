class Admins < ActiveRecord::Migration[7.0]
  def change
    drop_table :admins, if_exists: true
  end
end
