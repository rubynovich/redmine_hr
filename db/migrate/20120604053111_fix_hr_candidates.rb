class FixHrCandidates < ActiveRecord::Migration
  def self.up
    remove_column :hr_candidates, :to_do
    rename_column :hr_candidates, :done, :description
    add_column :hr_candidates, :author_id, :integer
    add_column :hr_candidates, :updated_on, :datetime
    add_column :hr_candidates, :created_on, :datetime
  end

  def self.down
    add_column :hr_candidates, :to_do, :text
    rename_column :hr_candidates, :description, :done    
    remove_column :hr_candidates, :author_id
    remove_column :hr_candidates, :updated_on
    remove_column :hr_candidates, :created_on
  end
end
