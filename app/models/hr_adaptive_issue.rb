class HrAdaptiveIssue < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :tracker
  belongs_to :hr_status
  belongs_to :assigned_to, :class_name => 'Principal', :foreign_key => 'assigned_to_id'
  belongs_to :priority, :class_name => 'IssuePriority', :foreign_key => 'priority_id'

  validates_presence_of :project_id, :tracker_id, :assigned_to_id,
    :priority_id, :subject, :start_date, :due_date, :hr_status_id

  @@start_date_variants = ["now", "fwd", "fwd_2w", "fwd_1m", "fwd_3m"]
  @@due_date_variants   = ["1d_fwd", "fwd", "fwd_2w", "fwd_1m", "fwd_3m"]

  cattr_accessor :due_date_variants, :start_date_variants

  if Rails::VERSION::MAJOR >= 3
    scope :on_status, lambda{ |hr_status_id|
      if hr_status_id.present?
        where(:hr_status_id => hr_status_id)
      end
    }
  else
    named_scope :on_status, lambda{ |hr_status_id|
      if hr_status_id.present?
        {:conditions => {:hr_status_id => hr_status_id}}
      end
    }
  end

  def create_issue(hr_candidate)
    issue = Issue.create(
      :status => IssueStatus.default,
      :tracker => self.tracker,
      :subject => [self.subject, hr_candidate.name].join(", "),
      :project => self.project,
      :description => [::I18n.t('message_about_hr_candidate', :name => hr_candidate.name, :job => hr_candidate.hr_job.name, :fwd => hr_candidate.due_date.strftime("%d.%m.%Y")), self.description].join("\n\n"),
      :author => User.current,
      :start_date => create_date(self.start_date, hr_candidate.due_date),
      :due_date => create_date(self.due_date, hr_candidate.due_date),
      :priority => self.priority,
      :assigned_to => self.assigned_to,
      :estimated_hours => self.estimated_hours
      )
    if issue && Redmine::Plugin.find(:redmine_planning)
      EstimatedTime.create(
            :issue => issue,
            :plan_on => issue.due_date,
            :user => issue.author,
            :comments => issue.subject,
            :hours => issue.estimated_hours)
    end
    issue
  end

  def create_date(str, fwd)
    case str
      when "now"
        Date.today
      when "1d_fwd"
        fwd - 1.day
      when "fwd"
        fwd
      when "fwd_2w"
        fwd + 2.weeks
      when "fwd_1m"
        fwd + 1.month
      when "fwd_3m"
        fwd + 2.months + 2.weeks
    end
  end

  def to_s
    subject
  end

  def to_hash
    self.class.column_names.
      inject({}) { |result, name|
        result.merge name => self.send(name)
      }
  end
end
