class OrdersController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def new
    if @cart.line_items.empty?
      flash.now[:warning] = '您的购物车里没有商品！'
      redirect_to current_user
      return 
    end

    member = current_user.member
  	@order = Order.new
    @order.member_id = member.id
    @order.organization_id = member.organization_id
    @order.created_by = member.user_id
  end

  def index
    @orders = Order.paginate(page: params[:page])
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    member = current_user.member
    @order = Order.new#(order_params)
    @order.member_id = member.id
    @order.organization_id = member.organization_id
    @order.created_by = member.user_id
    @order.status = 'placed'
    @order.total = @cart.total_price
    @order.add_line_items_from_cart(@cart)

    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      flash[:success] = "您的订单创建成功!"
      redirect_to current_user
    else
      render 'new'
    end

    # respond_to do |format|

    
    #     format.html { redirect_to store_url, notice: 
    #       'Thank you for your order.' }
    #     format.json { render action: 'show', status: :created,
    #       location: @order }
      
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @order.errors,
    #       status: :unprocessable_entity }
    #   end
    # end
  end

  def edit
  end

  def update
    if @order.update_attributes(order_params)
      flash[:success] = "订单信息已更新！"
      redirect_to @order
    else
      render 'edit'
    end
  end

  def destroy
    Order.find(params[:id]).destroy
    flash[:success] = "订单已被删除！"
    redirect_to orders_url
  end


  private

    def order_params
      params.require(:order).permit(:organization_id, :member_id, :ship_to, :status, :total, :created_by, :updated_by)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

end
