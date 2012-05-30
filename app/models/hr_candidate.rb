class HrCandidate < ActiveRecord::Base
  unloadable
  
  validates_presence_of :name, :scope => :birth_date
  validates_uniqueness_of :name
  
  belongs_to :job
  belongs_to :status

#  default :order => :name

  def to_s
    name
  end

  def is_closed?
    status.is_closed?
  end
end
