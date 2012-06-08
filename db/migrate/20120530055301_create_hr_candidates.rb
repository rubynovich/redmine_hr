class CreateHrCandidates < ActiveRecord::Migration
  def self.up
    create_table :hr_candidates do |t|
      t.column :name, :string, :default => ""
      t.column :phone, :string, :default => ""
      t.column :birth_date, :date
      t.column :due_date, :date, :null => false
      t.column :to_do, :text
      t.column :done, :text
      t.column :hr_status_id, :integer, :null => false
      t.column :hr_job_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :hr_candidates
  end
end
