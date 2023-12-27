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
    self.has_role?(:moderator)
  end

  def add_reader_role
    add_role(:reader)
  end

end
