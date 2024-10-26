class CreatePandaCmsPages < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:panda_cms_pages)
      create_table :panda_cms_pages, id: :uuid do |t|
        t.string :title
        t.string :path
        t.timestamps
      end
    end
  end
end
