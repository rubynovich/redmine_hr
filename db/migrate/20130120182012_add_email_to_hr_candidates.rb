class AddEmailToHrCandidates < ActiveRecord::Migration
  def self.up
    add_column :hr_candidates, :email, :string, :default => ""
  end

  def self.down
    remove_column :hr_candidates, :email
  end
end
