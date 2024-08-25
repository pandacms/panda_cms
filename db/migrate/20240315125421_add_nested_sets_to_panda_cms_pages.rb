class AddNestedSetsToPandaCmsPages < ActiveRecord::Migration[7.1]
  def self.up
    PandaCms::Page.where(parent_id: 0).update_all(parent_id: nil)
    add_column :panda_cms_pages, :lft, :integer
    add_column :panda_cms_pages, :rgt, :integer

    # This is necessary to update :lft and :rgt columns
    PandaCms::Page.reset_column_information
    PandaCms::Page.rebuild!
  end

  def self.down
    remove_column :panda_cms_pages, :lft
    remove_column :panda_cms_pages, :rgt
  end
end
