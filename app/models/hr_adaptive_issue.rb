class HrAdaptiveIssue < ActiveRecord::Base
  unloadable
  
  belongs_to :project
  belongs_to :tracker
  belongs_to :status, :class_name => 'IssueStatus', :foreign_key => 'status_id'
  belongs_to :assigned_to, :class_name => 'Principal', :foreign_key => 'assigned_to_id'
  belongs_to :priority, :class_name => 'IssuePriority', :foreign_key => 'priority_id'
  
  validates_presence_of :project_id, :tracker_id, :status_id, :assigned_to_id, 
    :priority_id, :subject, :start_date, :due_date
  
  @@start_date_variants = ["now", "fwd"]
  @@due_date_variants   = ["1d_fwd", "fwd", "fwd_2w", "fwd_1m", "fwd_3m"]
  
  cattr_accessor :due_date_variants, :start_date_variants
  
  def create_issue(hr_candidate)
    Issue.create(
      :status => IssueStatus.default, 
      :tracker => self.tracker, 
      :subject => self.subject, 
      :project => self.project, 
      :description => [::I18n.t('message_about_hr_candidate', :name => hr_candidate.name, :job => hr_candidate.hr_job.name, :fwd => hr_candidate.due_date.strftime("%d.%m.%Y")), self.description].join("\n\n"), 
      :author => User.current,
      :start_date => create_date(self.start_date, hr_candidate.due_date),
      :due_date => create_date(self.due_date, hr_candidate.due_date),
      :priority => self.priority,
      :assigned_to => self.assigned_to)
  end
  
  def create_date(str, fwd)
    case str
      when "now": Date.today
      when "1d_fwd": fwd - 1.day
      when "fwd": fwd
      when "fwd_2w": fwd + 1.week
      when "fwd_1m": fwd + 1.month
      when "fwd_3m": fwd + 2.months + 2.weeks
    end
  end
  
  def to_s
    subject
  end
end
