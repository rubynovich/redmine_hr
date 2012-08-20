class HrChangeDetail < ActiveRecord::Base
  unloadable

  belongs_to :hr_change
  before_save :normalize_values
  before_save :create_issues

  private

  def create_issues
    if (prop_key == "hr_status_id")&&(HrStatus.find(value).is_closed?)
      self.hr_change.notes += "\n\n" + self.hr_change.hr_candidate.create_issues.map{ |i| "##{i.id}"}.join(" ")
      self.hr_change.save
    end
  end

  def normalize_values
    self.value = normalize(value)
    self.old_value = normalize(old_value)
  end

  def normalize(v)
    if v == true
      "1"
    elsif v == false
      "0"
    else
      v
    end
  end
  
end
