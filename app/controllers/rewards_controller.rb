class RewardsController < ApplicationController

  before_action :set_reward, only: [:show]

  def index
    if current_user.member.master?
      #org_id = current_user.member.nil? ? 0 : current_user.member.organization_id
      #@rewards = Reward.by_organization(org_id).paginate(page: params[:page]) 
      @rewards = Reward.paginate(page: params[:page])
    end
  end

  def show
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reward_params
      params.require(:reward).permit(:order_id, :line_item_id, :member_id, :amount, :rate, :points, :created_by, :updated_by)
    end

    def set_reward
      @reward = Reward.find(params[:id])
    end
end
