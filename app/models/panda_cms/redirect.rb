module PandaCms
  class Redirect < ApplicationRecord
    belongs_to :origin_page, class_name: "PandaCms::Page", foreign_key: :origin_panda_cms_page_id
    belongs_to :destination_page, class_name: "PandaCms::Page", foreign_key: :destination_panda_cms_page_id

    validates :status_code, presence: true
    validates :visits, presence: true
  end
end
