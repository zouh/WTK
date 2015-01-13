 class UsersController < ApplicationController
    include CurrentCart

  before_action :set_cart, only: [:create, :show]
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: :destroy

  def new
  	@user = User.new
  end

  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    elsif current_member.master?
      #@users = User.joins(:member).where("organization_id = ?", current_member.organization_id).paginate(page: params[:page])
      @users = User.by_organization(current_member.organization_id).paginate(page: params[:page]) 
    end
  end

  def show
    #if current_member.angel? 
      #org_id = 0
      org_id =  current_member.organization_id unless current_member.nil? 
      @title = '商品'
      @user = current_user
      @products = Product.by_organization(org_id).paginate(page: params[:page])
      @orders = current_user.member.orders.paginate(page: params[:page])
    #end
  end

  def create
    inviter = invited_by(params[:invite_code])
    @user = User.new(user_params)
    if inviter.nil?
      # 邀请码不正确
      flash.now[:danger] = '请输入正确的邀请码！'
      render 'new'
    elsif inviter.user.nil? 
      # 用户是第一次注册的群管理员（master）或天使推客（angel）
      # 需要补充完整会员属性
      if @user.save
        sign_in @user
        inviter.user = @user
        inviter.name = @user.name
        inviter.save

        # 判断邀请码对应会员是否为root
        # true 则用户注册为群管理员（master）
        # false 则用户注册为天使推客（angel）
        @user.member.role = inviter.root? ? "master" : "angel"
        @user.member.save
        @user.save

        flash[:success] = "欢迎您使用微推客！"
        redirect_to @user
      else
        render 'new'
      end
    elsif inviter.user.master?
      # 群管理员（master）已注册，邀请码已失效
      flash.now[:warning] = '该邀请码已失效！'
      render 'new'
    else
      # 注册用户是普通会员，生成新的会员
      if @user.save
        sign_in @user    
        invitee = Member.create!(parent_id: inviter.id,
                                 organization_id: inviter.organization_id,
                                 invite_code: Member.create_invite_code,
                                 user_id: @user.id,
                                 name: @user.name,
                                 depth: inviter.depth + 1
                                )
        flash[:success] = "欢迎您使用微推客！"
        redirect_to @user
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "帐户信息已更新！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "帐户已被删除！"
    redirect_to users_url
  end

  def following
    @title = "关注"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "粉丝"
    @user = current_user #User.find(params[:id])
    @members = @user.member.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def orders
    @title = "订单"
    @user = current_user
    @orders = @user.member.orders_with_points.paginate(page: params[:page])
    render 'show_orders'
  end
  
  def rewards
    @title = "积分"
    @user = current_user
    @rewards = @user.member.rewards.order(created_at: :desc).paginate(page: params[:page])
    render 'show_rewards'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
    end

    # Before filters
    def correct_user
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound 
        @user = current_user
      end
      redirect_to(root_path) unless current_user?(@user)
    end

    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


    def invited_by(invite_code)
      Member.where("invite_code = ?", invite_code).first
    end

end