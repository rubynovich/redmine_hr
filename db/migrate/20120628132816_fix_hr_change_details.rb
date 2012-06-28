class FixHrChangeDetails < ActiveRecord::Migration
  def self.up
    change_column :hr_change_details, :old_value, :text, :null => true
    change_column :hr_change_details, :value, :text, :null => true
  end                                     

  def self.down
    change_column :hr_change_details, :old_value, :text, :null => false  
    change_column :hr_change_details, :value, :text, :null => false    
  end
end
