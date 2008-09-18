class AddDeletedToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :deleted, :boolean
  end

  def self.down
    remove_column :groups, :deleted
  end
end
