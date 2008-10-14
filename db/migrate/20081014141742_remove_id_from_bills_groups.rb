class RemoveIdFromBillsGroups < ActiveRecord::Migration
  def self.up
     remove_column :bills_groups, :id
  end

  def self.down
  end
end
