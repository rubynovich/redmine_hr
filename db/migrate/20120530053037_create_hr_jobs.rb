class CreateHrJobs < ActiveRecord::Migration
  def self.up
    create_table :hr_jobs do |t|
      t.column :name, :string, :default => ""
    end
  end

  def self.down
    drop_table :hr_jobs
  end
end
