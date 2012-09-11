class AddHrStatusId < ActiveRecord::Migration
  def self.up
    add_column :hr_adaptive_issues, :hr_status_id, :integer
  end

  def self.down
    remove_column :hr_adaptive_issues, :hr_status_id
  end
end
