class HrJobsController < ApplicationController
  unloadable
  before_filter :require_hr

  # GET /hr_jobs/
  def index
    @hr_job_pages, @hr_jobs = paginate :hr_jobs, :per_page => 25, :order => "name"
    render :action => "index", :layout => false if request.xhr?
  end

  # GET /hr_jobs/new
  def new
    @hr_job = HrJob.new
  end
  
  # POST /hr_jobs
  def create
    @hr_job = HrJob.new(params[:hr_job])
    if request.post? && @hr_job.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # GET /hr_jobs/1/edit
  def edit
    @hr_job = HrJob.find(params[:id])
  end

  # POST /hr_jobs
  def create
    @hr_job = HrJob.new(params[:hr_job])
    if request.post? && @hr_job.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # PUT /hr_jobs/1
  def update
    @hr_job = HrJob.find(params[:id])

    respond_to do |format|
      if @hr_job.update_attributes(params[:hr_job])
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(hr_jobs_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # DELETE /hr_jobs/1
  def destroy
    HrJob.find(params[:id]).destroy
    redirect_to :action => 'index'
  rescue
    flash[:error] = l(:error_unable_delete_hr_job)
    redirect_to :action => 'index'
  end  
  
  private
    def require_hr
      (render_403; return false) unless User.current.is_hr?
    end
end
