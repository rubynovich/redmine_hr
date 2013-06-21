class HrJobsController < ApplicationController
  unloadable
  before_filter :require_hr

  # GET /hr_jobs/
  def index
    @hr_job_pages, @hr_jobs = paginate :hr_jobs, :per_page => 25, :order => "name"

    respond_to do |format|
      format.html{ render :action => :index, :layout => !request.xhr? }
      format.json{ render :json => HrJob.all(:order => :name) }
    end
  end

  # GET /hr_jobs/new
  def new
    @hr_job = HrJob.new
  end

  # POST /hr_jobs
  def create
    @hr_job = HrJob.new(params[:hr_job])
    if @hr_job.save
      flash[:notice] = l(:notice_successful_create)
      redirect_back_or_default :action => 'index'
    else
      render :action => 'new'
    end
  end

  # GET /hr_jobs/1/edit
  def edit
    @hr_job = HrJob.find(params[:id])
  end

  # GET /hr_jobs/1
  def show
    @hr_job = HrJob.find(params[:id])
    @hr_candidate_pages, @hr_candidates = paginate :hr_candidates, :per_page => 25, :order => "due_date DESC", :conditions => ["hr_job_id=?", @hr_job.id]
  end

  # PUT /hr_jobs/1
  def update
    @hr_job = HrJob.find(params[:id])

      if @hr_job.update_attributes(params[:hr_job])
        flash[:notice] = l(:notice_successful_update)
        redirect_back_or_default :action => :index
      else
        render :action => "edit"
      end
  end

  # DELETE /hr_jobs/1
  def destroy
    HrJob.find(params[:id]).destroy rescue flash[:error] = l(:error_unable_delete_hr_job)
    redirect_back_or_default :action => 'index'
  end

  private
    def require_hr
      (render_403; return false) unless User.current.is_hr?
    end
end
