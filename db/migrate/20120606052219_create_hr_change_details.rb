class CreateHrChangeDetails < ActiveRecord::Migration
  def self.up
    create_table :hr_change_details do |t|
      t.column :hr_change_id, :integer, :null => false
      t.column :property, :string, :limit => 30, :default => "attr", :null => false
      t.column :prop_key, :string, :limit => 30, :null => false
      t.column :old_value, :text#, :null => false
      t.column :value, :text#, :null => false
    end
  end

  def self.down
    drop_table :hr_change_details
  end
end
