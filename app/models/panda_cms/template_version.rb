module PandaCms
  class TemplateVersion < Version
    self.table_name = :panda_cms_template_versions
    self.sequence_name = :panda_cms_template_versions_id_seq
  end
end
