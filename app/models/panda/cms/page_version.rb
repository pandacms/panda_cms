module Panda
  module CMS
    class PageVersion < Version
      self.table_name = :panda_cms_page_versions
      self.sequence_name = :panda_cms_page_versions_id_seq
    end
  end
end
