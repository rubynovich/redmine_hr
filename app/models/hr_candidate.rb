class HrCandidate < ActiveRecord::Base
  unloadable
  
  validates_presence_of :name, :scope => :birth_date
  validates_uniqueness_of :name
  validates_presence_of :hr_job_id
  validates_presence_of :hr_status_id  
  
  belongs_to :hr_job
  belongs_to :hr_status

  def to_s
    name
  end

  def is_closed?
    status.is_closed?
  end
end
