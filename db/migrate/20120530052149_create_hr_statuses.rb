class CreateHrStatuses < ActiveRecord::Migration
  def self.up
    create_table :hr_statuses do |t|
      t.column :name, :string, :default => "", :limit => 30
      t.column :is_closed, :boolean, :default => false, :null => false
      t.column :is_default, :boolean, :default => false, :null => false
      t.column :position, :integer, :default => 1, :null => false      
    end
  end

  def self.down
    drop_table :hr_statuses
  end
end
