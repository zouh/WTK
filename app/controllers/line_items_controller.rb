class LineItemsController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.js   { @current_item = @line_item }
        format.json { render action: 'show',
          status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
          status: :unprocessable_entity }
      end
    end

    # if @line_item.save
    #   @current_item = @line_item
    #   respond_with @cart
    #   redirect_to root_path
    # end
  end

  # PATCH/PUT /line_items/1
  def update
    @line_item.updated_by = current_user.id
    if @line_item.update_attributes(line_item_params)
      flash[:success] = '条目已更新！'
      redirect_to @line_item
    else
      render 'edit'
    end
  end

  # DELETE /line_items/1
  def destroy
    @line_item.destroy
    flash[:success] = "条目已被删除！"
    redirect_to line_items_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
  #...
end