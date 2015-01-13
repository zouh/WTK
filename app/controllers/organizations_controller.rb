class OrganizationsController < ApplicationController
  
  #before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  #before_action :master_user,  only: [:edit, :update]
  #before_action :admin_user,     only: [:destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def new
    @organization = Organization.new
  end

  def index
    @organizations = Organization.paginate(page: params[:page])
  end

  def show
  end

  def create
    @organization = current_user.organizations.build(organization_params)
    if @organization.save
      flash[:success] = "推客群创建成功!"
      redirect_to @organization
    else
      render 'new'
    end
  end

  def edit
    @organization.updated_by = current_user.id
  end

  def update
    @organization.updated_by = current_user.id
    if @organization.update_attributes(organization_params)
      flash[:success] = '推客群属性已更新！'
      redirect_to @organization
    else
      render 'edit'
    end
  end

  def destroy
    @organization.destroy
    flash[:success] = "推客群已被删除！"
    redirect_to organizations_url
  end

  def angels
    @title = "天使"
    @organization = Organization.find(params[:id])
    @members = @organization.registered_angels.paginate(page: params[:page])
    render 'show_members'
  end

  def partners
    @title = "伙伴"
    @organization = Organization.find(params[:id])
    @members = @organization.registered_partners.paginate(page: params[:page])
    render 'show_members'
  end

  def vips
    @title = "金牌会员"
    @organization = Organization.find(params[:id])
    @members = @organization.registered_vips.paginate(page: params[:page])
    render 'show_members'
  end

  def members
    @title = "会员"
    @organization = Organization.find(params[:id])
    @members = @organization.registered_members.paginate(page: params[:page])
    render 'show_members'
  end

  def aviliible_invite_codes
    @title = "天使邀请码"
    @organization = Organization.find(params[:id])
    @members = @organization.aviliible_invite_codes.paginate(page: params[:page])
    render 'show_members'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :contract, :invite_code, :logo_url, :capacity, :level, :period, 
                                           :rate1, :rate2, :rate3, :rate4, :rate5, :rate6, 
                                           :created_by, :updated_by)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end
end
