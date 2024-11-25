class RemovePostTagIdFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :panda_cms_posts, :post_tag_id if column_exists?(:panda_cms_posts, :post_tag_id)
  end
end
