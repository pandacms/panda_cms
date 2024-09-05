module PandaCms
  class User < ApplicationRecord
    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :email, presence: true, uniqueness: {case_sensitive: true}

    def is_admin?
      admin
    end

    def name
      "#{firstname} #{lastname}"
    end

    def self.for_select_list(scope = :all, order = {firstname: :asc, lastname: :asc})
      PandaCms::User.send(scope).order(order).map { |u| [u.name, u.id] }
    end
  end
end
