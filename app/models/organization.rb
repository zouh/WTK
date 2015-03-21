class Organization < ActiveRecord::Base
  # It will auto generate weixin token and secret
  include WeixinRailsMiddleware::AutoGenerateWeixinTokenSecretKey

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :products
  has_many :orders

  belongs_to :created_by_user, class_name: "User", foreign_key: "created_by"
  belongs_to :updated_by_user, class_name: "User", foreign_key: "updated_by"

  default_scope { order('name') }

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :capacity, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 5000, only_integer: true}
  validates :level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6, only_integer: true}
  #validates :rate1, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 5000, only_integer: true}
  validates :created_by, presence: true

  #serialize :rates, Hash

  after_initialize :default_values
  after_create :create_master
  after_save :create_invite_codes_for_angels

  def master
    members[0].nil? ? create_master : members[0]
  end


  def aviliible_invite_codes
    members.where("depth = 2 and user_id is null")
  end

  def registered_angels
    members.where("depth = 2 and user_id is not null")
  end

  def registered_partners
    members.where("role = ? and user_id is not null", Member.roles[:partner])
  end

  def registered_members
    members.where("role = ? and user_id is not null", Member.roles[:member])
  end

  def registered_vips
    members.where("role = ? and user_id is not null", Member.roles[:vip])
  end


  def rate
    rate = Array.new(7, 0)
    rate[0] = 100
    rate[1] = rate1
    rate[2] = rate2
    rate[3] = rate3
    rate[4] = rate4
    rate[5] = rate5
    rate[6] = rate6
    return rate    
  end

  def levels_for_scoring
    # if rate6 > 0
    #   sl = 6
    # elsif rate5 > 0    
    #   sl = 5 
    # elsif rate4 > 0
    #   sl = 4
    # elsif rate3 > 0
    #   sl = 3
    # elsif rate2 > 0
    #   sl = 2
    # elsif rate1 > 0
    #   sl = 1
    # else
    #   sl = 0
    # end
    return 2
  end

  def sales_total
    #orders.select("sum(price) as sales_total").group("date(created_at)")
    orders.sum(:total)
  end

  private
    def default_values
      if self.new_record?
        # values will be available for new record forms.
        self.capacity ||= 100 
        self.invite_code ||= ''
        self.level ||= 0
        self.period ||= 4
        self.rate1 ||= 0
        self.rate2 ||= 0
        self.rate3 ||= 0
        self.rate4 ||= 0
        self.rate5 ||= 0
        self.rate6 ||= 0
      end
    end

    def create_master
      members.create!(invite_code: self.invite_code, depth: 1)
    end

    def create_invite_codes_for_angels
      angels = self.capacity - members.count + 1
      master = members[0] unless members[0].nil? 
      angels.times do 
      members.create!(parent_id: master.id,
  	                  organization_id: self.id,
  	                  invite_code: Member.create_invite_code,
                      role: Member.roles[:angel],
  	                  depth: 2
  	                 )
        end
    end
end
