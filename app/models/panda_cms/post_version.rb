module PandaCms
  class PostVersion < Version
    self.table_name = :panda_cms_post_versions
    self.sequence_name = :panda_cms_post_versions_id_seq
  end
end
