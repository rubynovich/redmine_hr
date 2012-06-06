class HrChangeDetail < ActiveRecord::Base
  unloadable

  belongs_to :hr_change
  before_save :normalize_values

  private

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
