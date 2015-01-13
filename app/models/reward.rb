class Reward < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :member
  belongs_to :order
  belongs_to :created_by_user, class_name: "User", foreign_key: "created_by"
  belongs_to :updated_by_user, class_name: "User", foreign_key: "updated_by"

  default_scope { order(created_at: :desc) }
  #scope :by_organization, ->(org_id) {where(organization_id: org_id).order('name')} 
  
end
