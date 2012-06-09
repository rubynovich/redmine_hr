class ChangeBirthDateColumn < ActiveRecord::Migration
  def self.up
    change_column :hr_candidates, :birth_date, :date, :null => true
  end

  def self.down
    change_column :hr_candidates, :birth_date, :date, :null => false
  end
end
