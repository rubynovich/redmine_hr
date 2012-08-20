class CreateHrAdaptiveIssues < ActiveRecord::Migration
  def self.up
    create_table :hr_adaptive_issues do |t|
      t.column :subject, :string
      t.column :project_id, :integer
      t.column :description, :text
      t.column :start_date, :string
      t.column :due_date, :string
      t.column :tracker_id, :integer
      t.column :priority_id, :integer
      t.column :assigned_to_id, :integer
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :hr_adaptive_issues
  end
end
