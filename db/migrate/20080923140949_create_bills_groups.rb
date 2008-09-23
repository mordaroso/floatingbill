class CreateBillsGroups < ActiveRecord::Migration
  def self.up
    create_table :bills_groups do |t|
      t.integer :bill_id
      t.integer :group_id
    end
  end

  def self.down
    drop_table :bills_groups
  end
end
