class AddSanitizedPhonesToHrCandidates < ActiveRecord::Migration
  def self.up
    add_column :hr_candidates, :sanitized_phones, :string, :default => ""
  end

  def self.down
    remove_column :hr_candidates, :sanitized_phones
  end
end
