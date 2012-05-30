class HrStatusesController < ApplicationController
  unloadable

  before_filter :require_hr

  # GET /hr_statuses/
  def index
    @hr_status_pages, @hr_statuses = paginate :hr_statuses, :per_page => 25, :order => "position"
    render :action => "index", :layout => false if request.xhr?
  end

  # GET /hr_statuses/new
  def new
    @hr_status = HrStatus.new
  end
  
  # POST /hr_statuses
  def create
    @hr_status = HrStatus.new(params[:hr_status])
    if request.post? && @hr_status.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # GET /hr_statuses/1/edit
  def edit
    @hr_status = HrStatus.find(params[:id])
  end

  # POST /hr_statuses
  def create
    @hr_status = HrStatus.new(params[:hr_status])
    if request.post? && @hr_status.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # PUT /hr_statuses/1
  def update
    @hr_status = HrStatus.find(params[:id])

    respond_to do |format|
      if @hr_status.update_attributes(params[:hr_status])
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(hr_statuses_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # DELETE /hr_statuses/1
  def destroy
    HrStatus.find(params[:id]).destroy
    redirect_to :action => 'index'
  rescue
    flash[:error] = l(:error_unable_delete_hr_status)
    redirect_to :action => 'index'
  end  
  
  private
    def require_hr
      (render_403; return false) unless User.current.is_hr?
    end
end
