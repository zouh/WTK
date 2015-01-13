class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.references :order, index: true
      t.references :line_item, index: true
      t.references :member, index: true
      t.decimal :amount
      t.decimal :rate
      t.decimal :points
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
