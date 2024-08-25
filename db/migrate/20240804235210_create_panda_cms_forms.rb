class CreatePandaCmsForms < ActiveRecord::Migration[7.1]
  def change
    create_table :panda_cms_forms, id: :uuid do |t|
      t.string :name
      t.integer :submissions, default: 0
      t.timestamps
    end

    add_index :panda_cms_forms, :name, unique: true
  end
end
