class HrStatus < ActiveRecord::Base
  unloadable
  acts_as_list

  after_save     :update_default
  before_destroy :check_integrity
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :hr_candidates  
    
  def <=>(status)
    position <=> status.position
  end
  
  def update_default
    self.class.update_all("is_default=#{connection.quoted_false}", ['id <> ?', id]) if self.is_default?
  end
  
  def self.default
    find(:first, :conditions =>["is_default=?", true])
  end
  
  def to_s
    name
  end
  
  private
    def deletable?
      HrCandidate.eql_hr_status_id(self.id).count.zero?
    end
    
    def check_integrity
      raise "Can't delete hr_status" unless deletable?
    end  
end
