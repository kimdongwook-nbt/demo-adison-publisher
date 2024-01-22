class Admin < ApplicationRecord
  rolify
  after_create :add_publisher_role
  after_commit :update_role_cache, on: [:create, :update]
  after_destroy_commit :remove_role_cache

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  module AdminRoleCache
    KEY = 'admin_%{id}_roles'
  end

  class << self
    def search_by_email(email)
      if email
        Admin.where("email like :email", { email: "%#{email}%" })
      else
        Admin.all
      end
    end
  end

  def has_super_publisher?
    admin_roles = fetch_roles { roles_name }
    admin_roles.include?(DemoPublisherRole::SUPER_PUBLISHER)
  end

  def add_publisher_role
    add_role(DemoPublisherRole::PUBLISHER)
  end

  def update_role_cache
    fetch_roles { roles_name }
  end

  def remove_role_cache
    Rails.cache.delete(format(AdminRoleCache::KEY, id:))
  end

  private

  def fetch_roles(&)
    Rails.cache.fetch(format(AdminRoleCache::KEY, id:), expires_in: 30.minutes, &)
  end

end
