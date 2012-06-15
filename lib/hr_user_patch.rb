require_dependency 'user'

module HRUserPatch
  def self.included(base)
    base.extend(ClassMethods)
    
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      named_scope :not_hr, lambda {
        { :conditions => ["#{User.table_name}.id NOT IN (SELECT hr_members.user_id FROM hr_members)"] }
      }    
    end

  end
    
  module ClassMethods
  end
  
  module InstanceMethods
    def is_hr?
      HrMember.find_by_user_id(self.id).present?
    end
  end
end
