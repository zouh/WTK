namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_organizations
    #make_relationships
  end
end


def make_users
  # 系统管理员
  User.create!(
                name: "微推客管理员",
                email: "example@railstutorial.org",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456",
                admin: true
              )
  # 码客群管理员
  User.create!(
                name: "码客管理员",
                email: "admin@meeket.com",
                phone: "18910962226",
                password: "123456",
                password_confirmation: "123456"
              )          
  # 码客天使合伙人
  User.create!(
                name: "西安优财电子信息技术有限公司",
                email: "1@meeket.com",
                phone: "400-888-0000",
                password: "123456",
                password_confirmation: "123456"
              )

  User.create!(
                name: "西安易动广告有限公司",
                email: "11@meeket.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "宝鸡市连邦软件有限责任公司",
                email: "12@meeket.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "上海捷迈信息科技有限公司",
                email: "111@meeket.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "广州市羿蓝电子科技有限公司",
                email: "112@meeket.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "北京极致互联营销咨询有限公司",
                email: "121@meeket.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "山西世纪华光信息技术有限公司",
                email: "122@meeket.com",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "淄博万商联盟信息科技有限公司",
                email: "1111@meeket.com",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "黑龙江思迈信息技术服务有限公司",
                email: "1112@meeket.com",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "宁夏广森行商贸有限公司",
                email: "11111@meeket.com",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456"
              )

  # # 创建会员用户1-11
  # (1..11).each do |n|
  #   User.create!(
  #                 name: "会员#{n}",
  #                 email: "m#{n}@gfa8.com",
  #                 phone: Faker::PhoneNumber.cell_phone,
  #                 password: "123456",
  #                 password_confirmation: "123456"
  #               )
  # end 
  # 绿尚群管理员
  # User.create!(
  #               name: "绿尚客管理员",
  #               email: "gfa8@163.com",
  #               phone: "4008816611",
  #               password: "123456",
  #               password_confirmation: "123456"
  #             )   
end


def make_organizations
  #创建码客群
  meeket = Organization.create!(
                                  name:     "码客",
                                  logo_url:  "http://www.meeket.com/images/logo.png", 
                                  contract:  "京ICP备14007277号",
                                  capacity:  100,
                                  period: 4,
                                  invite_code: Member.create_invite_code,
                                  weixin_secret_key: 'b41c825fdf3dd3e3d51a42a6526b50ff',
                                  weixin_token: 'c9d856b5469fc63afa007f31',
                                  encoding_aes_key: 'fXjEvuDa2dMdiV8NcLGTo0m5RrWQ88SUe1msBUBBqBM',
                                  app_id: 'wxcc4c37da7948edc4',
                                  created_by: 1
                                )

  create_weixin_diymenu_for meeket

  # 创建码客群管理员
  master = User.find(2)
  mb = Member.find(1)
  mb.update!(user_id: master.id, name: master.name, role: 2)

  # 创建码客群天使推客
  angel = User.find(3)
  mb = Member.find(2)
  mb.update!(user_id: angel.id, name: angel.name)

  # 码客群的普通推客
  p = mb
  (3..4).each do |n| 
    u = User.find(n+1)
    x = meeket.members.create!(parent_id:   p.id,
                              user_id:      u.id,
                              name:         u.name,
                              invite_code:  Member.create_invite_code,
                              role:         4, 
                              depth:        p.depth+1)
  end

  p = Member.find(102)
  (5..6).each do |n| 
    u = User.find(n+1)
    x = meeket.members.create!(parent_id:   p.id,
                              user_id:      u.id,
                              name:         u.name,
                              invite_code:  Member.create_invite_code,
                              role:         4,
                              depth:        p.depth+1)
  end

  p = Member.find(103)
  (7..8).each do |n| 
    u = User.find(n+1)
    x = meeket.members.create!(parent_id:   p.id,
                              user_id:      u.id,
                              name:         u.name,
                              invite_code:  Member.create_invite_code,
                              role:         4,
                              depth:        p.depth+1)
  end

  p = Member.find(104)
  (9..10).each do |n| 
    u = User.find(n+1)
    x = meeket.members.create!(parent_id:   p.id,
                              user_id:      u.id,
                              name:         u.name,
                              invite_code:  Member.create_invite_code,
                              role:         4,
                              depth:        p.depth+1)
  end
  p = Member.find(108)
  (11..11).each do |n| 
    u = User.find(n+1)
    x = meeket.members.create!(parent_id:   p.id,
                              user_id:      u.id,
                              name:         u.name,
                              invite_code:  Member.create_invite_code,
                              depth:        p.depth+1)
  end

  # 码客群的产品
  #product_name = Faker::Commerce.product_name
  meeket.products.create!(
                          name:        '技术服务费',
                          description: '购买后成为码客的服务商，为客户提供专业的邀请函、商家名片、产品海报、活动促销、互动抽奖、优惠券等电子传单制作服务',
                          image_url:   'http://www.meeket.com/images/common/logo.png',
                          price:       7000.00,
                          retail:      7000.00,
                          wholesale:   0.00,
                          rate1:       30,
                          rate2:       10,
                          rate3:       0,
                          rate4:       0,
                          rate5:       0,
                          rate6:       0,
                          qualify:     true,
                          created_by:  master.id
                        )

  meeket.products.create!(
                          name:        '码客企业版',
                          description: '适合渠道模式、企业营销团队、连锁店等企业应用，支持单组织、多组织、跨组织的协同营销',
                          image_url:   'http://www.meeket.com/images/img/img_cz02.jpg',
                          price:       1000.00,
                          retail:      1000.00,
                          wholesale:   0.00,
                          rate1:       30,
                          rate2:       10,
                          rate3:       0,
                          rate4:       0,
                          rate5:       0,
                          rate6:       0,
                          created_by:  master.id
                        )

  meeket.products.create!(
                          name:        '码客个人版',
                          description: '适合直销经理、独立销售员、门店、小型网店等开展社交营销工作',
                          image_url:   'http://www.meeket.com/images/img/img_czdx.jpg',
                          price:       490.00,
                          retail:      490.00,
                          wholesale:   0.00,
                          rate1:       30,
                          rate2:       10,
                          rate3:       0,
                          rate4:       0,
                          rate5:       0,
                          rate6:       0,
                          created_by:  master.id
                        )


  # # 创建绿尚群
  # gfa8 = Organization.create!(
  #                               name:         "绿尚联盟",
  #                               logo_url:     "gfa8ud.jpg", 
  #                               contract:     "浙ICP备14037080号",
  #                               capacity:     100,
  #                               invite_code:  Member.create_invite_code,
  #                               created_by:   1
  #                             )
  # # 创建绿尚群管理员
  # u = User.find(3)
  # m = Member.find(102)
  # m.update!(user_id: u.id, name: u.name, role: 2)
  # # 创建绿尚群天使合伙人
  # u = User.find(4)
  # m = Member.find(103)
  # m.update!(user_id: u.id, name: u.name)
  # # 创建绿尚群加盟店
  # 5.times do |i|
  #   u = User.find(5+i) #A-E
  #   m = gfa8.members.create!(
  #                             parent_id:    m.id,
  #                             invite_code:  Member.create_invite_code,
  #                             user_id:      u.id,
  #                             name:         u.name,
  #                             depth:        3+i,
  #                             role:         4
  #                           )
  # end
  # # 金牌会员
  # u = User.find(10) #vip
  # m = gfa8.members.create!(
  #                           parent_id:    103,
  #                           invite_code:  Member.create_invite_code,
  #                           user_id:      u.id,
  #                           name:         u.name,
  #                           #role:         1,
  #                           depth:        3
  #                         )
  # # 金牌会员的下级会员
  # 10.times do |i|
  #   u = User.find(11+i) #1-10
  #   gfa8.members.create!(
  #                         parent_id:    m.id,
  #                         invite_code:  Member.create_invite_code,
  #                         user_id:      u.id,
  #                         name:         u.name,
  #                         depth:        4
  #                       )
  # end 
  # # 加盟店A的下级会员
  # u = User.find(21) #11
  # m = gfa8.members.create!(
  #                           parent_id:    203,
  #                           invite_code:  Member.create_invite_code,
  #                           user_id:      u.id,
  #                           name:         u.name,
  #                           depth:        4
  #                         )
  # # 创建绿尚群的产品
  # gfa8.products.create!(
  #                       name:         '加盟店保证金',
  #                       description:  '加盟店保证金',
  #                       image_url:    'http://gfa8.com.cn/uploads/140929/2-140929111F0407.png',
  #                       price:        50000.00,
  #                       retail:       50000.00,
  #                       wholesale:    0,
  #                       qualify:      true,
  #                       rate0:        50, 
  #                       rate1:        30,
  #                       rate2:        10,
  #                       rate3:        10,
  #                       created_by:   master.id
  #                     )  
  # gfa8.products.create!(
  #                       name:         '思维卡城市款',
  #                       description:  '平衡车又名：Segway、思维车、摄位车、体感车、智能平衡车。（中文翻译：赛格威；思维车）意即思维操纵，自由驾驶。是一种电力驱动、具有自我平衡能力的个人用运输载具',
  #                       image_url:    'http://gfa8.com.cn/uploads/141030/2-141030112252145.jpg',
  #                       price:        10800.00,
  #                       retail:       10800.00,
  #                       wholesale:    5400.00, 
  #                       rate0:        1, 
  #                       rate1:        80,
  #                       rate6:        10,
  #                       created_by:   master.id
  #                     )
  # gfa8.products.create!(
  #                       name:         '独轮车E-400',
  #                       description:  '采用专用踏板折叠吸附技术，使用最新航空铝合金材质，一级硬度，结实耐用。 经过最新科技加工，表面亚光拉丝，质感强，高档美观',
  #                       image_url:    'http://gfa8.com.cn/uploads/141030/2-141030110Q61C.jpg',
  #                       price:        4680.00,
  #                       retail:       4680.00,
  #                       wholesale:    2340.00,
  #                       rate0:        1, 
  #                       rate1:        80,
  #                       created_by:   master.id
  #                     ) 
  # gfa8.products.create!(
  #                       name:         '独轮车S500-174',
  #                       description:  '这款独占世界之最的SUPER MINI独轮 驾驭它，绝对看你胆识几何！ 征服它，你就是独一无二的勇士！',
  #                       image_url:    'http://gfa8.com.cn/uploads/141030/2-141030111204J1.jpg',
  #                       price:        3280.00,
  #                       retail:       3280.00,
  #                       wholesale:    1640.00,
  #                       rate0:        1, 
  #                       rate1:        80, 
  #                       created_by:   master.id
  #                     )


  # # #创建测试群
  # # test_org = Organization.create!(name:      "测试群",
  # #                                logo_url:  Faker::Company.logo, 
  # #                                contract:  Faker::Code.isbn,
  # #                                capacity:  100,
  # #                                period:    2,
  # #                                level:     3,
  # #                                rate1:     10,
  # #                                rate2:     5,
  # #                                rate3:     2,
  # #                                rate4:     0,
  # #                                rate5:     0,
  # #                                rate6:     0,
  # #                                invite_code: Member.create_invite_code,
  # #                                created_by: 1)
  # # # 创建群管理员
  # # user = User.find(3)
  # # mb = Member.find(2)
  # # mb.update!(user_id: user.id, name: user.name)



  # # # 码客群的产品
  # # 10.times do |i|
  # #   product_name = Faker::Commerce.product_name
  # #   meeket.products.create(name:        product_name,
  # #                          description: Faker::Lorem.paragraph,
  # #                          image_url:   Faker::Avatar.image(product_name),
  # #                          price:       Faker::Commerce.price,
  # #                          created_by:  user.id)
  # # end  


  # # 10.times do |n|
  # #   name = Faker::Company.name
  # #   logo = Faker::Company.logo
  # #   contract = Faker::Code.isbn
  # #   invite_code = Member.create_invite_code
  # #   org = Organization.create!(name:      name,
  # #                              logo_url:  logo, 
  # #                              contract:  contract,
  # #                              capacity:  100+n,
  # #                              period:    2,
  # #                              level:     3,
  # #                              rate1:     10,
  # #                              rate2:     5,
  # #                              rate3:     2,
  # #                              rate4:     0,
  # #                              rate5:     0,
  # #                              rate6:     0,
  # #                              invite_code: invite_code,
  # #                              created_by: 1
  # #                             )
  # # end
end

def create_weixin_diymenu_for (organization) 
  key = 'organizations/' + organization.id.to_s + '/products'
  menu_products = organization.diymenus.create!(
                                                  name:       '立即购买',
                                                  url:        'http://wtk.meeket.com/' + key,
                                                  is_show:    true,
                                                  sort:       0
                                                )
  key = 'my_qrcode'
  menu_qrcode = organization.diymenus.create!(
                                                name:       '我的二维码',
                                                key:        key,
                                                is_show:    true,
                                                sort:       1
                                              )
  organization.generate_weixin_menu
end
