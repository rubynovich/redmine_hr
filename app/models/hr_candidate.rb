class HrCandidate < ActiveRecord::Base
  unloadable
  acts_as_attachable :after_add => :attachment_added, :after_remove => :attachment_removed

  validates_uniqueness_of :name, :scope => :birth_date, :if => "birth_date.present?"
  validates_uniqueness_of :name, :if => "birth_date.blank?"
  validates_presence_of :name, :hr_job_id, :hr_status_id, :due_date
  validates_format_of :phone, :with => /^(\d{10}|)$/,
    :message => I18n.t(:message_incorrect_format_phone)
  validates_format_of :due_date, :with => /^(19\d{2}-\d{2}-\d{2}|20\d{2}-\d{2}-\d{2})$/
  validates_format_of :birth_date, :with => /^(19\d{2}-\d{2}-\d{2}|20\d{2}-\d{2}-\d{2}|)$/
  validate :validate_due_date, :unless => "hr_status.is_closed?"

  attr_accessor :project

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :hr_job
  belongs_to :hr_status
  has_many :hr_changes, :dependent => :destroy

  after_update :save_hr_change

  if Rails::VERSION::MAJOR >= 3
    scope :like_name, lambda {|q|
      if q.present?
        {:conditions =>
          ["LOWER(name) LIKE :p OR name LIKE :p",
          {:p => "%#{q.to_s.downcase}%"}]}
      end
    }

    scope :like_field, lambda {|q|
      if q.present?
        {:conditions =>
          ["phone LIKE :p",
          {:p => "%#{q.to_s.downcase}%"}]}
      end
    }

    scope :eql_field, lambda {|q, field|
      if q.present? && field.present?
        where(field => q)
      end
    }

    # FIXME -> eql_field
#    scope :eql_hr_job_id, lambda {|q|
#      if q.present?
#        where(:hr_job_id => q)
#      end
#    }
#
#    scope :eql_hr_status_id, lambda {|q|
#      if q.present?
#        where(:hr_status_id => q)
#      end
#    }
#
#    scope :eql_due_date, lambda {|q|
#      if q.present?
#        where(:due_date => q)
#      end
#    }

#    scope :eql_birth_date, lambda {|q|
#      if q.present?
#        where(:birth_date => q)
#      end
#    }

    scope :period_time_period, lambda {|q|
      today = Date.today
      if q.present?
        {:conditions =>
          (case q
            when "yesterday"
              {:due_date => 1.day.ago}
            when "today"
              {:due_date => today}
            when "tomorrow"
              {:due_date => 1.day.from_now}
            when "this_week"
              ["due_date BETWEEN ? AND ?",
                today,
                1.week.from_now - today.wday.days]
            when "next_week"
              ["due_date BETWEEN ? AND ?",
                1.week.from_now - today.wday.days,
                2.week.from_now - today.wday.days]
            when "this_month"
              ["due_date BETWEEN ? AND ?",
                today,
                1.month.from_now - today.day.days]
            when "next_month"
              ["due_date BETWEEN ? AND ?",
                1.month.from_now - today.day.days,
                2.month.from_now - today.day.days]
            else
              {}
          end)
        }
      end
    }
  else
    named_scope :like_name, lambda {|q|
      if q.present?
        {:conditions =>
          ["LOWER(name) LIKE :p OR name LIKE :p",
          {:p => "%#{q.to_s.downcase}%"}]}
      end
    }

    named_scope :like_field, lambda {|q|
      if q.present?
        {:conditions =>
          ["phone LIKE :p",
          {:p => "%#{q.to_s.downcase}%"}]}
      end
    }

    named_scope :eql_field, lambda {|q, field|
      if q.present? && field.present?
        where(field => q)
      end
    }

    # FIXME -> eql_field
#    named_scope :eql_hr_job_id, lambda {|q|
#      if q.present?
#        {:conditions => {:hr_job_id => q}}
#      end
#    }

#    named_scope :eql_hr_status_id, lambda {|q|
#      if q.present?
#        {:conditions => {:hr_status_id => q}}
#      end
#    }

#    named_scope :eql_due_date, lambda {|q|
#      if q.present?
#        {:conditions => {:due_date => q}}
#      end
#    }

#    named_scope :eql_birth_date, lambda {|q|
#      if q.present?
#        {:conditions => {:birth_date => q}}
#      end
#    }

    named_scope :period_time_period, lambda {|q|
      today = Date.today
      if q.present?
        {:conditions =>
          (case q
            when "yesterday"
              {:due_date => 1.day.ago}
            when "today"
              {:due_date => today}
            when "tomorrow"
              {:due_date => 1.day.from_now}
            when "this_week"
              ["due_date BETWEEN ? AND ?",
                today,
                1.week.from_now - today.wday.days]
            when "next_week"
              ["due_date BETWEEN ? AND ?",
                1.week.from_now - today.wday.days,
                2.week.from_now - today.wday.days]
            when "this_month"
              ["due_date BETWEEN ? AND ?",
                today,
                1.month.from_now - today.day.days]
            when "next_month"
              ["due_date BETWEEN ? AND ?",
                1.month.from_now - today.day.days,
                2.month.from_now - today.day.days]
            else
              {}
          end)
        }
      end
    }
  end

  def to_s
    name
  end

  def is_closed?
    status.is_closed?
  end

  def validate_due_date
    if self.due_date and self.due_date < Date.today
      errors.add :due_date, :greated_then_now
    end
  end

  def init_hr_change(notes)
    @current_hr_change ||= HrChange.new(:hr_candidate_id => self.id, :user => User.current, :notes => notes)
    @attributes_before_change = attributes.dup
    # Make sure updated_on is updated when adding a note.
    updated_on_will_change!
    @current_hr_change
  end

  def save_hr_change
    if @current_hr_change
      # attributes changes
      if @attributes_before_change
        (HrCandidate.column_names - %w(id description birth_date author_id created_on updated_on)).each do |c|
          before = @attributes_before_change[c]
          after = send(c)
          next if before == after || (before.blank? && after.blank?)
          @current_hr_change.hr_change_details << HrChangeDetail.new(
            :property => 'attr',
            :prop_key => c,
            :old_value => before,
            :value => after)
        end
      end
      @current_hr_change.save
    end
  end

  def attachments_visible?(user=User.current)
    user.is_hr?
  end

  def attachments_deletable?(user=User.current)
    user.is_hr?
  end

  def editable_by?(user=User.current)
    user.is_hr?
  end

  def destroyable_by?(user=User.current)
    user.is_hr?
  end

  def attachment_added(obj)
    if @current_hr_change && !obj.new_record?
      @current_hr_change.hr_change_details << HrChangeDetail.new(:property => 'attachment', :prop_key => obj.id, :value => obj.filename)
    end
  end

  def attachment_removed(obj)
    init_hr_change(nil)
    if @current_hr_change && !obj.new_record?
      @current_hr_change.hr_change_details << HrChangeDetail.new(:property => 'attachment', :prop_key => obj.id, :old_value => obj.filename)
      @current_hr_change.save
    end
  end

  def create_issues(hr_status_id)
    HrAdaptiveIssue.on_status(hr_status_id).map do |issue|
      issue.create_issue(self)
    end
  end
end
