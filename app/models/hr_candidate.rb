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
  
  attr_accessor :notes

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
end
