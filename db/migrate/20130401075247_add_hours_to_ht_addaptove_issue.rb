class AddHoursToHtAddaptoveIssue < ActiveRecord::Migration
  def change
    add_column :hr_adaptive_issues, :hours, :float, :default => 0.0
  end
end
