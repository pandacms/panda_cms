module PandaCms
  class User < ApplicationRecord
    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :email, presence: true, uniqueness: {case_sensitive: true}
  end

  def is_admin?
    admin
  end

  def name
    "#{firstname} #{lastname}"
  end
end
