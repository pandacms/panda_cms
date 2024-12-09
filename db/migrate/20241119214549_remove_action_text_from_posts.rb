class RemoveActionTextFromPosts < ActiveRecord::Migration[7.1]
  def up
    remove_column :panda_cms_posts, :post_content
  end

  def down
    add_column :panda_cms_posts, :post_content, :text
  end
end
