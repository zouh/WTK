class StaticPagesController < ApplicationController

  def home
    if signed_in?
      if current_user.admin?
        redirect_to organizations_path
      elsif current_member.master?
        redirect_to current_user.member.organization
      else
        redirect_to current_user
      end
    end 
  end

  def help
  end

  def about
  end

  def contact
  end

  def docs
  end

end
