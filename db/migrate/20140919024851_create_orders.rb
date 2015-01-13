class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :organization, index: true
      t.string :oid
      t.references :member, index: true
      t.integer :ship_to
      t.integer :status
      t.decimal :total
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
