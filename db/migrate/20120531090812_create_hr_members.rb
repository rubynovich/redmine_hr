class CreateHrMembers < ActiveRecord::Migration
  def self.up
    create_table :hr_members do |t|
      t.column :user_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :hr_members
  end
end
