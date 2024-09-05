module PandaCms
  class PostTag < ApplicationRecord
    self.table_name = "panda_cms_post_tags"

    validates :tag, presence: true
  end
end
