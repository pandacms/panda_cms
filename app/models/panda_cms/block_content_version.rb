module PandaCms
  class BlockContentVersion < Version
    self.table_name = :panda_cms_block_content_versions
    self.sequence_name = :panda_cms_block_content_versions_id_seq
  end
end
