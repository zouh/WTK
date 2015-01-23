module WTK

  module Entities  
    class User < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
        expose :oid, as: :id
        expose :name, documentation: { type: "String", desc: "用户名称" }
        expose :avatar_url, documentation: { type: "String", desc: "用户头像地址" }
        expose :email, documentation: { type: "String", desc: "用户电子邮件" }
        expose :phone, documentation: { type: "String", desc: "用户电话" }
        
        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :updated_at
        end
    end
  end


  class Users < Grape::API

    resource :users do

      desc "创建一个用户"
      params do
        requires :id, type: String, desc: "用户ID"
        requires :name, type: String, desc: "用户名称"
        requires :password, type: String, desc: "用户密码（最少6位数字或字母）"
        optional :avatar_url, type: String, desc: "用户头像地址"
        requires :email, type: String, desc: "用户电子邮件"
        optional :phone, type: String, desc: "用户电话"
      end
      post do
        @suer = User.create!(
                      oid:          params[:id],
                      name:         params[:name],
                      avatar_url:   params[:avatar_url], 
                      email:        params[:email], 
                      phone:        params[:phone],
                      password:     "123456",
                      password_confirmation: "123456"
                    )
        present @user, :with => Entities::User
      end

      
      desc "列出全部用户"
      get do
        @users = User.where.not(oid: nil)
        present @users, :with => Entities::User
      end


      desc '查询指定的用户'
      params do
        requires :id, type: Integer, desc: '用户ID'
      end
      route_param :id do
        get do
        begin
          @user = User.find_by(oid: params[:id])
          present @user, :with => Entities::User
          rescue ActiveRecord::RecordNotFound 
            error!('未找到指定的用户', 404)
          end
          #@org || error!('未找到对应的推客群', 404)
        end
      end


      desc '修改指定的用户信息'
      params do
        requires :id, type: String, desc: "用户ID"
        requires :name, type: String, desc: "用户名称"
        optional :avatar_url, type: String, desc: "用户头像地址"
        #optional :phone, type: String, desc: "用户电话"
      end
      put ':id' do
      begin
        @user = User.find_by(oid: params[:id])       
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的用户', 404)
        end 
        @user.update_column :name, params[:name] if params[:name]
        @user.update_column :avatar_url, params[:avatar_url] if params[:avatar_url]
        present @user, :with => Entities::User
      end


      desc "删除指定用户"
      params do
        requires :id, type: String, desc: "用户ID"
      end
      delete ':id' do
      begin
        @user = User.find_by(oid: params[:id])
        present @user, :with => Entities::User
        @user.destroy!
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的用户', 404)
        end 
      end

    end
  end

end

