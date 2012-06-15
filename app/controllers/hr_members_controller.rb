class HrMembersController < ApplicationController
  unloadable
  layout 'admin'

  before_filter :require_admin

  def index
    @hr_members = HrMember.all
  end 
  
  def create
    users = User.find_all_by_id(params[:user_ids])
    users.each do |user|
      HrMember.create(:user_id => user.id)
    end if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'hr_members', :action => 'index'}
      format.js {
        render(:update) {|page|
          page.replace_html "content-users", :partial => 'users'
          users.each {|user| page.visual_effect(:highlight, "user-#{user.id}") }
        }
      }
    end
  end

  def destroy
    HrMember.find(params[:id]).destroy if request.delete?
    @hr_members = HrMember.all
    redirect_to :controller => 'hr_members', :action => 'index'
  end    
end
