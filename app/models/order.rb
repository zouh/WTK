class Order < ActiveRecord::Base

  enum status:[ :placed, :paid, :confirmed, :delivered, :received, :completed ]

  belongs_to :organization
  belongs_to :member
  belongs_to :created_by_user, class_name: "User", foreign_key: "created_by"
  belongs_to :updated_by_user, class_name: "User", foreign_key: "updated_by"

  has_many :line_items, dependent: :destroy
  has_many :rewards, dependent: :destroy

  default_scope { order(created_at: :desc) }
  scope :for_scoring, ->(member_id) {where("member_id = ? and status <> ?", member_id, Order.statuses[:completed])} 
  scope :by_organization, ->(org_id) {where(organization_id: org_id).order(created_at: :desc)} 

  after_create :reward_following # 订单保存后计算各上级会员的奖励返利

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  #private  
    # 计算各上级会员的分成
    def reward_following
      ids = Array.new
      # 以产品为主线，根据设置，计算上级会员应得的分成
      line_items.each do |l|
        # 成为伙伴
        p = l.product
        if p.qualify 
          member.role = 4
          member.save
        end
        # 根据上级会员的角色和产品分成比例设置，计算上级会员分成
        member.ancestors.each do |m|
          rate = 0.0
          if m.partner? || m.angel?
            scale = member.depth - m.depth 
            rate = p.partner_rate[scale]
          elsif m.vip?
            rate = p.vip_rate
          #elsif m.angel?
          #  rate = p.angel_rate
          elsif m.member? 
            rate = 0.0 
          elsif m.master?
            rate = 0.0                    
          end
          if rate > 0
            r = Reward.create!(
                                member_id:    m.id,
                                order_id:     id,
                                line_item_id: l.id,
                                amount:       l.total_price,
                                rate:         rate,
                                points:       (l.total_price * rate / 100.0).to_i,
                                created_by:   member.user_id
                              )
            m.points += r.points
            m.save
          end
          #ids << [p.name, m.name, rate, r.points]
        end
        
      end
      ids
    end
end
