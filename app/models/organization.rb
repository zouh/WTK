class Organization < ActiveRecord::Base
  # It will auto generate weixin token and secret
  #include WeixinRailsMiddleware::AutoGenerateWeixinTokenSecretKey

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :products
  has_many :orders
  # 自定义菜单
  has_many :diymenus, dependent: :destroy

  # 当前公众账号的所有父级菜单
  has_many :parent_menus, ->{includes(:sub_menus).where(parent_id: nil, is_show: true).order("sort").limit(3)}, class_name: "Diymenu", foreign_key: :organization_id

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
    return 0    
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

  def build_menu
    Jbuilder.encode do |json|
      json.button (parent_menus) do |menu|
        json.name menu.name
        if menu.has_sub_menu?
          json.sub_button(menu.sub_menus) do |sub_menu|
            json.type sub_menu.type
            json.name sub_menu.name
            sub_menu.button_type(json)
          end
        else
          json.type menu.type
          menu.button_type(json)
        end
      end
    end
  end

  def generate_weixin_menu
    # 结合: https://github.com/lanrion/weixin_authorize(建议选用此gem的Redis存access_token方案)
    weixin_client = WeixinAuthorize::Client.new(app_id, weixin_secret_key)
    if weixin_client.is_valid?
      menu = build_menu
      result = weixin_client.create_menu(menu)
      url = weixin_client.create_qr_limit_scene(scene_str: invite_code)
      user_info = weixin_client.user('oLNBjuIHJZkhtFzbquLezErObOzk')
      #byebug
      #Rails.logger.debug(result["errmsg"]) if result["errcode"] != 0
    end
    #redirect_to organization_diymenus_path(@organization)
  end

  private
    def default_values
      if self.new_record?
        # values will be available for new record forms.
        self.capacity ||= 100 
        self.invite_code ||= ''
        self.level ||= 0
        self.period ||= 4
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
