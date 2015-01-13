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
                name: "系统管理员",
                email: "example@railstutorial.org",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456",
                admin: true
              )
  # 码客群管理员
  User.create!(
                name: "码客管理员",
                email: "example-1@railstutorial.org",
                phone: "18910962226",
                password: "123456",
                password_confirmation: "123456"
              )
  # 绿尚群管理员
  User.create!(
                name: "绿尚客管理员",
                email: "gfa8@163.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )           
  # 绿尚天使合伙人
  User.create!(
                name: "天使合伙人",
                email: "a@gfa8.com",
                phone: "400-888-0000",
                password: "123456",
                password_confirmation: "123456"
              )
  # 绿尚加盟店
  User.create!(
                name: "加盟店A",
                email: "pa@gfa8.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "加盟店B",
                email: "pb@gfa8.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "加盟店C",
                email: "pc@gfa8.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "加盟店D",
                email: "pd@gfa8.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "加盟店E",
                email: "pe@gfa8.com",
                phone: "4008816611",
                password: "123456",
                password_confirmation: "123456"
              )
  User.create!(
                name: "金牌会员",
                email: "vip@gfa8.com",
                phone: Faker::PhoneNumber.cell_phone,
                password: "123456",
                password_confirmation: "123456"
              )
  # 创建会员用户1-11
  (1..11).each do |n|
    User.create!(
                  name: "会员#{n}",
                  email: "m#{n}@gfa8.com",
                  phone: Faker::PhoneNumber.cell_phone,
                  password: "123456",
                  password_confirmation: "123456"
                )
  end   
  # # 码客天使推客
  # User.create!(
  #               name: Faker::Name.name,
  #               email: "example-2@railstutorial.org",
  #               phone: Faker::PhoneNumber.cell_phone,
  #               password: "123456",
  #               password_confirmation: "123456"
  #             )
  # # 码客普通推客
  # (3..8).each do |n|
  #   name  = Faker::Name.name
  #   email = "example-#{n}@railstutorial.org"
  #   phone ＝ phone: Faker::PhoneNumber.cell_phone
  #   password  = "123456"
  #   User.create!(
  #                 name: name,
  #                 email: email,
  #                 email: phone,
  #                 password: password,
  #                 password_confirmation: password
  #               )
  # end 
end


def make_organizations
  #创建码客群
  meeket = Organization.create!(
                                  name:     "码客",
                                  logo_url:  "http://www.meeket.com/images/logo.png", 
                                  contract:  "京ICP备14007277号",
                                  capacity:  100,
                                  invite_code: Member.create_invite_code,
                                  created_by: 1
                                )
  # 创建码客群管理员
  master = User.find(2)
  mb = Member.find(1)
  mb.update!(user_id: master.id, name: master.name, role: 2)

  # # 创建码客群天使推客
  # angel = User.find(3)
  # mb = Member.find(2)
  # mb.update!(user_id: angel.id, name: angel.name)

  # # 码客群的普通推客
  # p = 2
  # (3..11).each do |n| 
  #   u = User.find(n+1)
  #   x = meeket.members.create!(parent_id: p,
  #                           user_id:      u.id,
  #                           name:         u.name,
  #                           invite_code:  Member.create_invite_code,
  #                           depth:        n)
  #   p = x.id
  # end

  # 码客群的产品
  #product_name = Faker::Commerce.product_name
  meeket.products.create!(
                          name:        '企业版',
                          description: '企业版码客适合渠道模式、企业营销团队、连锁店等企业应用，支持单组织、多组织、跨组织的协同营销',
                          image_url:   'http://www.meeket.com/images/img/img_cz02.jpg',
                          price:       3980.00,
                          retail:      3980.00,
                          wholesale:   1990.00,
                          created_by:  master.id
                        )

  meeket.products.create!(
                          name:        '个人版',
                          description: '个人版适合直销经理、独立销售员、门店、小型网店等开展社交营销工作',
                          image_url:   'http://www.meeket.com/images/img/img_czdx.jpg',
                          price:       980.00,
                          retail:      980.00,
                          wholesale:   490.00,
                          created_by:  master.id
                        )

  # 创建绿尚群
  gfa8 = Organization.create!(
                                name:         "绿尚联盟",
                                logo_url:     "gfa8ud.jpg", 
                                contract:     "浙ICP备14037080号",
                                capacity:     100,
                                invite_code:  Member.create_invite_code,
                                created_by:   1
                              )
  # 创建绿尚群管理员
  u = User.find(3)
  m = Member.find(102)
  m.update!(user_id: u.id, name: u.name, role: 2)
  # 创建绿尚群天使合伙人
  u = User.find(4)
  m = Member.find(103)
  m.update!(user_id: u.id, name: u.name)
  # 创建绿尚群加盟店
  5.times do |i|
    u = User.find(5+i) #A-E
    m = gfa8.members.create!(
                              parent_id:    m.id,
                              invite_code:  Member.create_invite_code,
                              user_id:      u.id,
                              name:         u.name,
                              depth:        3+i,
                              role:         4
                            )
  end
  # 金牌会员
  u = User.find(10) #vip
  m = gfa8.members.create!(
                            parent_id:    103,
                            invite_code:  Member.create_invite_code,
                            user_id:      u.id,
                            name:         u.name,
                            role:         1,
                            depth:        3
                          )
  # 金牌会员的下级会员
  10.times do |i|
    u = User.find(11+i) #1-10
    gfa8.members.create!(
                          parent_id:    m.id,
                          invite_code:  Member.create_invite_code,
                          user_id:      u.id,
                          name:         u.name,
                          depth:        4
                        )
  end 
  # 加盟店A的下级会员
  u = User.find(21) #11
  m = gfa8.members.create!(
                            parent_id:    203,
                            invite_code:  Member.create_invite_code,
                            user_id:      u.id,
                            name:         u.name,
                            depth:        4
                          )
  # 创建绿尚群的产品
  gfa8.products.create!(
                        name:         '加盟店保证金',
                        description:  '加盟店保证金',
                        image_url:    'http://gfa8.com.cn/uploads/140929/2-140929111F0407.png',
                        price:        50000.00,
                        retail:       50000.00,
                        wholesale:    0,
                        qualify:      true,
                        rate0:        50, 
                        rate1:        30,
                        rate2:        10,
                        rate3:        10,
                        created_by:   master.id
                      )  
  gfa8.products.create!(
                        name:         '思维卡城市款',
                        description:  '平衡车又名：Segway、思维车、摄位车、体感车、智能平衡车。（中文翻译：赛格威；思维车）意即思维操纵，自由驾驶。是一种电力驱动、具有自我平衡能力的个人用运输载具',
                        image_url:    'http://gfa8.com.cn/uploads/141030/2-141030112252145.jpg',
                        price:        10800.00,
                        retail:       10800.00,
                        wholesale:    5400.00, 
                        rate0:        1, 
                        rate1:        80,
                        rate6:        10,
                        created_by:   master.id
                      )
  gfa8.products.create!(
                        name:         '独轮车E-400',
                        description:  '采用专用踏板折叠吸附技术，使用最新航空铝合金材质，一级硬度，结实耐用。 经过最新科技加工，表面亚光拉丝，质感强，高档美观',
                        image_url:    'http://gfa8.com.cn/uploads/141030/2-141030110Q61C.jpg',
                        price:        4680.00,
                        retail:       4680.00,
                        wholesale:    2340.00,
                        rate0:        1, 
                        rate1:        80,
                        created_by:   master.id
                      ) 
  gfa8.products.create!(
                        name:         '独轮车S500-174',
                        description:  '这款独占世界之最的SUPER MINI独轮 驾驭它，绝对看你胆识几何！ 征服它，你就是独一无二的勇士！',
                        image_url:    'http://gfa8.com.cn/uploads/141030/2-141030111204J1.jpg',
                        price:        3280.00,
                        retail:       3280.00,
                        wholesale:    1640.00,
                        rate0:        1, 
                        rate1:        80, 
                        created_by:   master.id
                      )


  # #创建测试群
  # test_org = Organization.create!(name:      "测试群",
  #                                logo_url:  Faker::Company.logo, 
  #                                contract:  Faker::Code.isbn,
  #                                capacity:  100,
  #                                period:    2,
  #                                level:     3,
  #                                rate1:     10,
  #                                rate2:     5,
  #                                rate3:     2,
  #                                rate4:     0,
  #                                rate5:     0,
  #                                rate6:     0,
  #                                invite_code: Member.create_invite_code,
  #                                created_by: 1)
  # # 创建群管理员
  # user = User.find(3)
  # mb = Member.find(2)
  # mb.update!(user_id: user.id, name: user.name)



  # # 码客群的产品
  # 10.times do |i|
  #   product_name = Faker::Commerce.product_name
  #   meeket.products.create(name:        product_name,
  #                          description: Faker::Lorem.paragraph,
  #                          image_url:   Faker::Avatar.image(product_name),
  #                          price:       Faker::Commerce.price,
  #                          created_by:  user.id)
  # end  


  # 10.times do |n|
  #   name = Faker::Company.name
  #   logo = Faker::Company.logo
  #   contract = Faker::Code.isbn
  #   invite_code = Member.create_invite_code
  #   org = Organization.create!(name:      name,
  #                              logo_url:  logo, 
  #                              contract:  contract,
  #                              capacity:  100+n,
  #                              period:    2,
  #                              level:     3,
  #                              rate1:     10,
  #                              rate2:     5,
  #                              rate3:     2,
  #                              rate4:     0,
  #                              rate5:     0,
  #                              rate6:     0,
  #                              invite_code: invite_code,
  #                              created_by: 1
  #                             )
  # end
end

def make_relationships
  users = User.all()
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end




