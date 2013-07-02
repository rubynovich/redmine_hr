class HrMembersController < ApplicationController
  unloadable
  layout 'admin'

  before_filter :require_admin
  before_filter :get_hr_members, :only => [:index]

  def index
  end

  def create
    users = User.find(params[:user_ids])
    users.each do |user|
      HrMember.create(:user_id => user.id)
    end
    get_hr_members
#    redirect_to :controller => 'hr_members', :action => 'index'
  end

  def destroy
    HrMember.find(params[:id]).destroy
    get_hr_members
#    if request.delete?
#    redirect_to :action => 'index'
  end

  private

    def get_hr_members
      @hr_members = HrMember.all
    end
end
