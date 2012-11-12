require_dependency 'principal'
require_dependency 'user'

module HRPlugin
  module UserPatch
    def self.included(base)
      base.extend(ClassMethods)
      
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        if Rails::VERSION::MAJOR >= 3 
          scope :not_hr, where("#{User.table_name}.id NOT IN (SELECT hr_members.user_id FROM hr_members)")    
        else
          named_scope :not_hr, lambda {
            { :conditions => ["#{User.table_name}.id NOT IN (SELECT hr_members.user_id FROM hr_members)"] }
          }    
        end
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
end
