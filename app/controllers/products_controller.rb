class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def index
    if !current_user.nil?
      if current_user.admin?
        @products = Product.paginate(page: params[:page])
      else
        org_id = current_user.member.nil? ? 0 : current_user.member.organization_id
        @products = Product.by_organization(org_id).paginate(page: params[:page]) 
      end
    end
  end

  def show
  end

  def create
    @product = current_user.member.organization.products.build(product_params)
    @product.created_by = current_user.id if current_member.master?
    if @product.save
      flash[:success] = "商品创建成功!"
      redirect_to @product
    else
      render 'new'
    end
  end

  def edit
    @product.updated_by = current_user.id
  end

  def update
    @product.updated_by = current_user.id
    if @product.update_attributes(product_params)
      flash[:success] = '商品属性已更新！'
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    flash[:success] = "商品已被删除！"
    redirect_to products_url
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:organization_id, :name, :description, :image_url, :qualify,
                                      :rate0, :rate1, :rate2, :rate3, :rate4, :rate5, :rate6, 
                                      :price, :retail, :wholesale, :created_by, :updated_by)
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
