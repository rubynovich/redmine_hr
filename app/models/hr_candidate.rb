class HrCandidate < ActiveRecord::Base
  unloadable
  
  validates_presence_of :name, :scope => :birth_date
  validates_uniqueness_of :name
  validates_presence_of :hr_job_id, :hr_status_id, :due_date, :birth_date
  validates_format_of :phone, :with => /^(\d{10}|)$/,
    :message => I18n.t(:message_incorrect_format_phone)
  validate :validate_due_date
  
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'    
  belongs_to :hr_job
  belongs_to :hr_status
  has_many :hr_changes
  
  after_update :save_hr_change

  named_scope :like_name, lambda {|q|
    if q.present?
      {:conditions => 
        ["LOWER(name) LIKE :p OR name LIKE :p", 
        {:p => "%#{q.to_s.downcase}%"}]}
    end
  }
  
  named_scope :like_phone, lambda {|q|
    if q.present?
      {:conditions => 
        ["phone LIKE :p", 
        {:p => "%#{q.to_s.downcase}%"}]}
    end
  }

  named_scope :eql_hr_job_id, lambda {|q|
    if q.present?
      {:conditions => {:hr_job_id => q}}
    end
  }
  
  named_scope :eql_hr_status_id, lambda {|q|
    if q.present?
      {:conditions => {:hr_status_id => q}}
    end
  }
  
  named_scope :eql_due_date, lambda {|q|
    if q.present?
      {:conditions => {:due_date => q}}
    end
  }

  named_scope :eql_birth_date, lambda {|q|
    if q.present?
      {:conditions => {:birth_date => q}}
    end
  }
  
  def to_s
    name
  end

  def is_closed?
    status.is_closed?
  end
  
  def validate_due_date
    if self.due_date and self.due_date < Date.today
      errors.add :due_date, :invalid      
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
        (HrCandidate.column_names - %w(id description author_id created_on updated_on)).each do |c|
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
end
