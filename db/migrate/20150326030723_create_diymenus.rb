class CreateDiymenus < ActiveRecord::Migration
  def change
    create_table :diymenus do |t|
      t.references :organization, index: true
      t.integer :parent_id # 所属父级菜单，如果当前是父级菜单，则此值为空
      t.string :name
      t.string :key  
      t.string :url
      t.boolean :is_show # 是否显示
      t.integer :sort    # 排序功能
      t.timestamps null: false
    end
    add_foreign_key :diymenus, :organizations

    add_index :diymenus, :parent_id
    add_index :diymenus, :key
  end
end