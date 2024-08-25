class AddNestedToPandaCmsMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :panda_cms_menu_items, :parent_id, :uuid
    add_column :panda_cms_menu_items, :lft, :integer
    add_column :panda_cms_menu_items, :rgt, :integer
    add_column :panda_cms_menu_items, :depth, :integer
    add_column :panda_cms_menu_items, :children_count, :integer, null: false, default: 0

    add_index :panda_cms_menu_items, :lft
    add_index :panda_cms_menu_items, :rgt

    PandaCms::MenuItem.reset_column_information
    PandaCms::MenuItem.rebuild!

    # Update pages whilst we're at it
    add_column :panda_cms_pages, :depth, :integer
    add_column :panda_cms_pages, :children_count, :integer, null: false, default: 0
    add_index :panda_cms_pages, :lft
    add_index :panda_cms_pages, :rgt

    PandaCms::Page.reset_column_information
    PandaCms::Page.rebuild!
  end
end
