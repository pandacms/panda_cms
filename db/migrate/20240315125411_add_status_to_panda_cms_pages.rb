class AddStatusToPandaCmsPages < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:panda_cms_pages, :status)
      create_enum :panda_cms_page_status, ["active", "draft", "hidden", "archived"]
      add_column :panda_cms_pages, :status, :panda_cms_page_status, default: "active", null: false
      add_index :panda_cms_pages, :status
    end
  end
end
