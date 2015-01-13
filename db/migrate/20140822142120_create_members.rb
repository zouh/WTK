class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :parent_id
      t.references :organization, index: true
      t.string :invite_code
      t.references :user, index: true
      t.string :name
      t.integer :depth, default: 0
      t.integer :children_count, default: 0
      t.integer :points, default: 0
      t.integer :role, default: 0
      #t.boolean :active default: true

      t.timestamps
    end

    add_index :members, :parent_id
    add_index :members, :depth
    add_index :members, :invite_code, unique: true
  end
end
