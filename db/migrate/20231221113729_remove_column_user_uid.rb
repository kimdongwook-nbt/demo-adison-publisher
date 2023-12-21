class RemoveColumnUserUid < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :uid
  end
end
