class HrCandidatesController < ApplicationController
  unloadable
  before_filter :require_hr

  helper :attachments
  include AttachmentsHelper
  helper :sort
  include SortHelper

  # GET /hr_candidates/
  def index
    sort_init 'due_date', 'desc'
    sort_update %w(name birth_date phone hr_status_id hr_job_id due_date)
    
    @limit = per_page_option
    
    scope = HrCandidate.
      like_name(params[:name]).
      like_phone(params[:phone]).
      eql_hr_job_id(params[:hr_job_id]).
      eql_hr_status_id(params[:hr_status_id]).
      eql_birth_date(params[:birth_date]).
      eql_due_date(params[:due_date]).
      period_time_period(params[:time_period])
    
    @hr_candidate_count = scope.count
    @hr_candidate_pages = Paginator.new self, @hr_candidate_count, @limit, params[:page]
    @offset ||= @hr_candidate_pages.current.offset
    @hr_candidates =  scope.find  :all,
                                  :order => sort_clause,
                                  :limit  =>  @limit,
                                  :offset =>  @offset    
  end

  # GET /hr_candidates/new
  def new
    @hr_candidate = HrCandidate.new(:hr_status => HrStatus.default, :author_id =>  User.current.id)
  end
  
  # GET /hr_candidates/1/edit
  def edit
    @hr_candidate = HrCandidate.find(params[:id])
  end

  # GET /hr_candidates/1
  def show
    @hr_candidate = HrCandidate.find(params[:id])
    @hr_changes = @hr_candidate.hr_changes.find(:all, :order => "created_on DESC")
  end

  # POST /hr_candidates
  def create
    @hr_candidate = HrCandidate.new(params[:hr_candidate])
    @hr_candidate.save_attachments(params[:attachments] || (params[:hr_candidate] && params[:hr_candidate][:uploads]))
    if request.post? && @hr_candidate.save
      render_attachment_warning_if_needed(@hr_candidate)    
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  # PUT /hr_candidates/1
  def update
    @hr_candidate = HrCandidate.find(params[:id])    
    @hr_candidate.init_hr_change(params[:notes])    
    @hr_candidate.save_attachments(params[:attachments] || (params[:hr_candidate] && params[:hr_candidate][:uploads]))        
    respond_to do |format|
      if @hr_candidate.update_attributes(params[:hr_candidate])
        render_attachment_warning_if_needed(@hr_candidate)          
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(hr_candidate_path(@hr_candidate)) }
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
