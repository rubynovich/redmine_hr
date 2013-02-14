class HrStatusesController < ApplicationController
  unloadable

  before_filter :require_hr

  # GET /hr_statuses/
  def index
    @hr_status_pages, @hr_statuses = paginate :hr_statuses, :per_page => 25, :order => "position"
  end

  # GET /hr_statuses/new
  def new
    @hr_status = HrStatus.new
  end

  # POST /hr_statuses
  def create
    @hr_status = HrStatus.new(params[:hr_status])
    if @hr_status.save
      flash[:notice] = l(:notice_successful_create)
      redirect_back_or_default :action => 'index'
    else
      render :action => 'new'
    end
  end

  # GET /hr_statuses/1/edit
  def edit
    @hr_status = HrStatus.find(params[:id])
  end

  # GET /hr_statuses/1
  def show
    @hr_status = HrStatus.find(params[:id])
    @hr_candidate_pages, @hr_candidates = paginate :hr_candidates, :per_page => 25, :order => "due_date DESC", :conditions => ["hr_status_id=?", @hr_status.id]
  end

  # PUT /hr_statuses/1
  def update
    @hr_status = HrStatus.find(params[:id])

    if @hr_status.update_attributes(params[:hr_status])
      flash[:notice] = l(:notice_successful_update)
      redirect_back_or_default :action => :index
    else
      render :action => "edit"
    end
  end

  # DELETE /hr_statuses/1
  def destroy
    HrStatus.find(params[:id]).destroy rescue flash[:error] = l(:error_unable_delete_hr_status)
    redirect_back_or_default :action => 'index'
  end

  private
    def require_hr
      (render_403; return false) unless User.current.is_hr?
    end
end
