class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :organization, index: true
      t.string :oid
      t.string :name
      t.text :description
      t.string :image_url
      t.decimal :price, precision: 8, scale: 2
      t.decimal :retail, precision: 8, scale: 2
      t.decimal :wholesale, precision: 8, scale: 2
      t.boolean :qualify, default: false
      t.decimal :rate0, default: 0
      t.decimal :rate1, default: 0
      t.decimal :rate2, default: 0
      t.decimal :rate3, default: 0
      t.decimal :rate4, default: 0
      t.decimal :rate5, default: 0
      t.decimal :rate6, default: 0
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    add_index :products, [:organization_id, :name], unique: true 
  end
end
