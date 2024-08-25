module PandaCms
  class Visit < ApplicationRecord
    belongs_to :page, class_name: "PandaCms::Page", foreign_key: :page_id, optional: true
    belongs_to :user, class_name: "PandaCms::User", foreign_key: :user_id, optional: true
    belongs_to :redirect, class_name: "PandaCms::Redirect", foreign_key: :redirect_id, optional: true
  end
end
