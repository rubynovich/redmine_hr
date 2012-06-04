class HrCandidatesController < ApplicationController
  unloadable
  before_filter :require_hr

  # GET /hr_candidates/
  def index
    @hr_candidate_pages, @hr_candidates = paginate :hr_candidates, :per_page => 25, :order => "due_date DESC"
    render :action => "index", :layout => false if request.xhr?
  end

  # GET /hr_candidates/new
  def new
    @hr_candidate = HrCandidate.new(:hr_status => HrStatus.default, :author_id =>  User.current.id)
  end
  
  # POST /hr_candidates
  def create
    @hr_candidate = HrCandidate.new(params[:hr_candidate])
    if request.post? && @hr_candidate.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # GET /hr_candidates/1/edit
  def edit
    @hr_candidate = HrCandidate.find(params[:id])
  end

  # GET /hr_candidates/1
  def show
    @hr_candidate = HrCandidate.find(params[:id])
  end

  # POST /hr_candidates
  def create
    @hr_candidate = HrCandidate.new(params[:hr_candidate])
    if request.post? && @hr_candidate.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # PUT /hr_candidates/1
  def update
    @hr_candidate = HrCandidate.find(params[:id])

    respond_to do |format|
      if @hr_candidate.update_attributes(params[:hr_candidate])
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(hr_candidates_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # DELETE /hr_candidates/1
  def destroy
    HrCandidate.find(params[:id]).destroy
    redirect_to :action => 'index'
  rescue
    flash[:error] = l(:error_unable_delete_hr_candidate)
    redirect_to :action => 'index'
  end  
  
  private
    def require_hr
      (render_403; return false) unless User.current.is_hr?
    end
end
