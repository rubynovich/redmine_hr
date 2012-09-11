class HrMembersController < ApplicationController
  unloadable
  layout 'admin'

  before_filter :require_admin

  def index
    @hr_members = HrMember.all
  end 
  
  def create
    users = User.find(params[:user_ids])
    users.each do |user|
      HrMember.create(:user_id => user.id)
    end
    redirect_to :controller => 'hr_members', :action => 'index'
  end

  def destroy
    HrMember.find(params[:id]).destroy if request.delete?
    redirect_to :action => 'index'
  end    
end
