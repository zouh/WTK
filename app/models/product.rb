class Product < ActiveRecord::Base

  belongs_to :created_by_user, class_name: "User", foreign_key: "created_by"
  belongs_to :updated_by_user, class_name: "User", foreign_key: "updated_by"
  belongs_to :organization, counter_cache: true

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  
  default_scope { order('organization_id').order('name') }
  scope :by_organization, ->(org_id) {where(organization_id: org_id).order('name')} 

  validates :name, :description, :image_url, presence: true
  validates :name, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :price, numericality: {greater_than_or_equal_to: 0.01}  
  #validates :image_url, allow_blank: true, format: {
  #  with:    %r{\.(gif|jpg|png)\Z}i,
  #  message: 'must be a URL for GIF, JPG or PNG image.' }
  validates :created_by, presence: true

  def self.latest 
    Product.order(:updated_at).last
  end

  def rate
    rate = Array.new(7, 0)
    rate[0] = rate0
    rate[1] = rate1
    rate[2] = rate2
    rate[3] = rate3
    rate[4] = rate4
    rate[5] = rate5
    rate[6] = rate6
    return rate    
  end
 
  def angel_rate
    return rate0
  end
  
  def vip_rate
    return rate6
  end

  def partner_rate
    rate = Array.new(6, 0)
    rate[0] = 0
    rate[1] = rate1
    rate[2] = rate2
    rate[3] = rate3
    rate[4] = rate4
    rate[5] = rate5
    return rate 
  end

  def levels_for_scoring
    sl = 0
    if rate5 > 0    
      sl = 5 
    elsif rate4 > 0
      sl = 4
    elsif rate3 > 0
      sl = 3
    elsif rate2 > 0
      sl = 2
    elsif rate1 > 0
      sl = 1 
    end
  end
    
  private
    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item 
      if line_items.empty?
        return true 
      else
        errors.add(:base, 'Line Items present')
        return false 
      end
    end

end
