class CreateHrChanges < ActiveRecord::Migration
  def self.up
    create_table :hr_changes do |t|
      t.column :hr_candidate_id, :integer, :null => false
      t.column :notes, :text
      t.column :user_id, :integer, :null => false
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :hr_changes
  end
end
