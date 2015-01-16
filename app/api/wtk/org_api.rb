module WTK
  class OrgAPI < Grape::API

    resource :organizations do

      desc "创建一个推客群"
      params do
        requires :name, type: String, desc: "推客群名称"
        requires :logo_url, type: String, desc: "推客群Logo地址"
        requires :contract, type: String, desc: "推客群Logo地址"
      end
      post do
        Organization.create!(
                              name:         params[:name],
                              logo_url:     params[:logo_url], 
                              contract:     params[:contract], 
                              capacity:     100,
                              invite_code:  Member.create_invite_code,
                              created_by:   1
                            )
      end

      
      desc "列出全部推客群"
      get do
        Organization.all
      end

      desc '查询指定的推客群'
      params do
        requires :id, type: Integer, desc: '推客群ID'
      end
      route_param :id do
        get do
        begin
          @org = Organization.find(params[:id].to_i)
          rescue ActiveRecord::RecordNotFound 
            error!('未找到指定的推客群', 404)
          end
          #@org || error!('未找到对应的推客群', 404)
        end
      end


      desc '修改指定的推客群信息'
      params do
        requires :id, type: String, desc: '推客群ID'
        requires :name, type: String, desc: "推客群名称"
        requires :logo_url, type: String, desc: "推客群Logo地址"
      end
      put ':id' do
      begin
        @org = Organization.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的推客群', 404)
        end 
        @org.name = params[:name]
        @org.logo_url = params[:logo_url]
        @org.save 
      end


      desc "删除指定推客群"
      params do
        requires :id, type: String, desc: "推客群ID"
      end
      delete ':id' do
      begin
        @org = Organization.find(params[:id].to_i)
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的推客群', 404)
        end 
        #authenticate!
        @org.destroy
      end

      # TEST api for testing uploading
      # curl --form file=@splines.png http://localhost:9292/splines/upload
      # desc 'Update image'
      # post 'upload' do
      #   filename = params[:file][:filename]
      #   content_type 'application/octet-stream'
      #   env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
      #   header 'Content-Disposition', "attachment; filename*=UTF-8''#{URI.escape(filename)}"
      #   params[:file][:tempfile].read
      # end
    end
  end

end

