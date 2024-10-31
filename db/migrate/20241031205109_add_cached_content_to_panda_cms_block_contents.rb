class AddCachedContentToPandaCmsBlockContents < ActiveRecord::Migration[7.2]
  def change
    add_column :panda_cms_block_contents, :cached_content, :jsonb, after: :content
  end
end
