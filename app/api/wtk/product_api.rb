module WTK

  module Entities
    
    class Product < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
        expose :oid
        expose :name
        expose :description, documentation: { type: "String", desc: "产品描述." }
        expose :retail
        
        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :updated_at
        end
    end
  end

  class ProductAPI < Grape::API

    resource :products do

      desc "创建一个商品"
      params do
        requires :id, type: String, desc: "商品ID"
        requires :name, type: String, desc: "商品名称"
        requires :description, type: String, desc: "商品描述"
        optional :image, type: String, desc: "商品图片地址"
        requires :price, type: String, desc: "商品实际价格"
        requires :retail, type: String, desc: "商品零售价格"
        requires :wholesale, type: String, desc: "商品加盟价格"
      end
      post do
        Product.create!(
                          organization_id: 2,
                          oid:          params[:id],
                          name:         params[:name],
                          description:  params[:description],
                          image_url:    params[:image],
                          price:        params[:price],
                          retail:       params[:retail],
                          wholesale:    params[:wholesale],
                          created_by:   3
                        )
      end

      
      desc "列出全部商品"
      get do
        # Product.where(organization_id: 2)
        present Product.where(organization_id: 2), :with => Entities::Product
      end


      desc '查询指定的商品'
      params do
        requires :id, type: String, desc: '商品ID'
      end
      route_param :id do
        get do
        begin
          @product = Product.find_by(oid: params[:id])
          rescue ActiveRecord::RecordNotFound 
            error!('未找到指定的商品', 404)
          end
          #@org || error!('未找到对应的推客群', 404)
        end
      end


      desc '修改指定商品的信息'
      params do
        requires :id, type: String, desc: "商品ID"
        optional :name, type: String, desc: "商品名称"
        optional :description, type: String, desc: "商品描述"
        optional :image, type: String, desc: "商品图片地址"
        optional :price, type: String, desc: "商品实际价格"
        optional :retail, type: String, desc: "商品零售价格"
        optional :wholesale, type: String, desc: "商品加盟价格"
      end
      put ':id' do
      begin
        @product = Product.find_by(oid: params[:id])
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的商品', 404)
        end
        @product.name = params[:name] if params[:name]
        @product.description = params[:description] if params[:description]
        @product.image_url = params[:image] if params[:image]
        @product.price = params[:price] if params[:price]
        @product.retail = params[:retail] if params[:retail]
        @product.wholesale = params[:wholesale] if params[:wholesale]
        @product.save!
      end

      desc "删除指定商品"
      params do
        requires :id, type: String, desc: "商品ID"
      end
      delete ':id' do
      begin
        @product = Product.find_by(oid: params[:id])
        rescue ActiveRecord::RecordNotFound 
          error!('未找到指定的商品', 404)
        end 
        #authenticate!
        @product.destroy!
      end

    end
  end
end

