class HrJob < ActiveRecord::Base
  unloadable
  before_destroy :check_integrity  
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :candidates
  
  def is_closed?
    false  
#    HrCandidate.find(:first, :conditions => ["hr_status_id=?", self.id])
  end
  
  def to_s
    name
  end
  
  private
    def check_integrity
#      raise "Can't delete hr_status" if HrCandidate.find(:first, :conditions => ["hr_status_id=?", self.id])
    end    
end
