class HrChange < ActiveRecord::Base
  unloadable
  
  belongs_to :hr_candidate
  belongs_to :user
  has_many :hr_change_details, :dependent => :destroy

  def save(*args)
    # Do not save an empty journal
    (hr_change_details.empty? && notes.blank?) ? false : super
  end

  # Returns a string of css classes
  def css_classes
    s = 'journal'
    s << ' has-notes' unless notes.blank?
    s << ' has-details' unless hr_change_details.blank?
    s
  end
  
  def new_value_for(prop)
    c = hr_change_details.detect {|detail| detail.prop_key == prop}
    c ? c.value : nil
  end
end
