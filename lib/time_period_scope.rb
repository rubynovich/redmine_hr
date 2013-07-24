module TimePeriodScope
  def self.included(base)
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do

      unloadable

      unless singleton_methods.include? :time_periods
        def time_periods
          %w{yesterday last_week this_week last_month this_month last_year this_year any}
        end
      end

      scope :time_period, lambda {|q, field|
        today = Date.today
        if q.present?
          period_start, period_end = case q
                                     when "yesterday"
                                       [1.day.ago.beginning_of_day, 1.day.ago.end_of_day ]
                                     when "today"
                                       [today.beginning_of_day, today.end_of_day ]
                                     when "last_week"
                                       [1.week.ago.beginning_of_week, 1.week.ago.end_of_week ]
                                     when "this_week"
                                       [ today.beginning_of_week, today.end_of_week]
                                     when "last_month"
                                       [1.month.ago.beginning_of_month, 1.month.ago.end_of_month]
                                     when "this_month"
                                       [today.beginning_of_month, today.end_of_month]
                                     when "last_year"
                                       [1.year.ago.beginning_of_year, 1.year.ago.end_of_year ]
                                     when "this_year"
                                       [today.beginning_of_year, today.end_of_year ]
                                     when "any"
                                     end            
          if field.present? && period_start.present?
            conditions = ["#{field} BETWEEN ? AND ?", period_start , period_end]
          end
          
          {:conditions => conditions}

        end
      }

    end

  end

  module ClassMethods
  end

  module InstanceMethods
  end

end
