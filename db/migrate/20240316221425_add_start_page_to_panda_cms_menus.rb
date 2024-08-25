class AddStartPageToPandaCmsMenus < ActiveRecord::Migration[7.1]
  def change
    add_reference :panda_cms_menus, :start_page, type: :uuid, foreign_key: {to_table: :panda_cms_pages}
  end
end
