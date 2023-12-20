class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    # primary_key 를 다르게 생성할 경우 아래 세 가지 작업을 하라
    # 1. create_table 메서드 파라미터에 -> id: false 추가
    # 2. t.primary_key :pk_name
    # 3. Record 클래스에 self.primary_key = :pk_name
    create_table :admins, id: false do |t| # create_table 메서드는 id 컬럼(auto_increment)을 기본으로 추가한다.
      t.primary_key :admin_id
      t.string :email, unique: true, null: false
      t.string :encrypted_password, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
