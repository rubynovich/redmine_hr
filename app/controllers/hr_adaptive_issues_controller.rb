class HrAdaptiveIssuesController < ApplicationController
  unloadable
  before_filter :require_hr
  before_filter :find_object, :only => [:edit, :show, :destroy, :update]

  def index
    @hr_adaptive_issues = HrAdaptiveIssue.all
  end
  
  def new
    @hr_adaptive_issue = HrAdaptiveIssue.new
  end
  
  def edit
  end
  
  def show
  end
    
  def create
    @hr_adaptive_issue = HrAdaptiveIssue.new params[:hr_adaptive_issue]
    if @hr_adaptive_issue.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => :new
    end      
  end
  
  def update
    if @hr_adaptive_issue.update_attributes(params[:hr_adaptive_issue])
      flash[:notice] = l(:notice_successful_update)
      redirect_to(hr_adaptive_issue_path(@hr_adaptive_issue))
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @hr_adaptive_issue.destroy
    redirect_to :action => 'index'
  rescue
    flash[:error] = l(:error_unable_delete_hr_adaptive_issue)
    redirect_to :action => 'index'
  end  


  private
  
    def find_object
      @hr_adaptive_issue = HrAdaptiveIssue.find(params[:id])    
    end
  
    def require_hr
      (render_403; return false) unless User.current.is_hr?
    end
end
