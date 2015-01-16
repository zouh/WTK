module WTK
  class UserAPI < Grape::API

    resource :users do

      desc "创建一个用户"
      params do
        requires :id, type: String, desc: "用户ID"
        requires :name, type: String, desc: "用户名称"
        requires :password, type: String, desc: "用户密码（最少6位数字或字母）"
        optional :avatar, type: String, desc: "用户头像地址"
        requires :email, type: String, desc: "用户电子邮件"
        optional :phone, type: String, desc: "用户电话"
      end
      post do
        User.create!(
                      oid:          params[:id],
                      name:         params[:name],
                      avatar_url:   params[:avatar], 
                      email:        params[:email], 
                      phone:        params[:phone],
                      password:     "123456",
                      password_confirmation: "123456"
                    )
      end

      
      desc "列出全部用户"
      get do
        User.all
      end


      desc '查询指定的用户'
      params do
        requires :id, type: Integer, desc: '用户ID'
      end
      route_param :id do
        get do
        begin
          @user = User.find_by(oid: params[:id])
          rescue ActiveRecord::RecordNotFound 
            error!('未找到指定的用户', 404)
          end
          #@org || error!('未找到对应的推客群', 404)
        end
      end


      # desc '修改指定的用户信息'
      # params do
      #   requires :id, type: String, desc: "用户ID"
      #   requires :name, type: String, desc: "用户名称"
      #   #optional :avatar, type: String, desc: "用户头像地址"
      #   #optional :phone, type: String, desc: "用户电话"
      # end
      # put ':id' do
      # begin
      #   @user = User.find_by(oid: params[:id])
      #   rescue ActiveRecord::RecordNotFound 
      #     error!('未找到指定的用户', 404)
      #   end 
      #   @user.update!(name: params[:name])
      # end

      desc "删除指定用户"
      params do
        requires :id, type: String, desc: "用户ID"
      end
      delete ':id' do
      begin
        @user = User.find_by(oid: params[:id])
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的用户', 404)
        end 
        #authenticate!
        @user.destroy!
      end

    end
  end

end

