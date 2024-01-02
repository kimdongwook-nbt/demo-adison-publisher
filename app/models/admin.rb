class Admin < ApplicationRecord
  rolify
  after_create :add_reader_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  class << self
    def search_by_email(email)
      if email
        Admin.where("email like :email", { email: "%#{email}%" })
      else
        Admin.all
      end
    end
  end

  def has_moderator?
    admin_roles = fetch_or_save_roles { roles_name }
    admin_roles.include?(:moderator.to_s)
  end

  def add_reader_role
    add_role(:reader)
    fetch_or_save_roles { ['reader'] }
  end

  private

  def fetch_or_save_roles(&)
    Rails.cache.fetch("admin_#{id}_roles", expires_in: 12.hours, &)
  end

end
