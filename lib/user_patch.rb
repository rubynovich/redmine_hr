require_dependency 'user'

module HR
  def self.included(base)
    base.extend(ClassMethods)
    
    base.send(:include, InstanceMethods)
    
    base.class_eval do
    end

  end
    
  module ClassMethods
  end
  
  module InstanceMethods
    def is_hr?
      true
    end
  end
end
