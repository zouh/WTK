class CartsController < ApplicationController
  include CurrentCart

  #skip_before_action :authorize, only: [:create, :update, :destroy]
  before_action :set_cart
  #before_action :set_cart_to_show,
  #              only: [:set, :show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  	 #@cart = Cart.find(params[:id])
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # GET /carts/1/set
  def set
    set_current_cart(@cart)
    respond_to do |format|
      format.html { redirect_to @cart, notice: 'Current cart successfully switched.' }
      format.json { render action: 'show', status: :found, location: cart }
    end
  end

  # POST /carts
  # POST /carts.json
  def create
    cart = Cart.new(cart_params)

    respond_to do |format|
      if cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render action: 'show', status: :created, location: cart }
        set_current_cart cart
      else
        format.html { render action: 'new' }
        format.json { render json: cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy() if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to user_path }
      format.js { render action: 'destroy'}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_to_show
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params[:cart]
    end

    def invalid_cart
      #notify_admin
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'Invalid cart'
    end
end