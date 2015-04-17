class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string    :name
      t.string    :contract
      t.string    :invite_code
      t.string    :logo_url
      t.integer   :capacity
      t.integer   :level
      t.integer   :period
      t.integer   :members_count, default: 0
      t.integer   :products_count, default: 0
      t.string    :weixin_secret_key
      t.string    :weixin_token
      t.string    :encoding_aes_key, limit: 43
      t.string    :app_id
      t.integer   :created_by
      t.integer   :updated_by

      t.timestamps
    end
    
    add_index :organizations, :name, unique: true
    add_index :organizations, :weixin_secret_key
    add_index :organizations, :weixin_token   
  end
end
