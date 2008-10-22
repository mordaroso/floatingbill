class RemoveAcceptedFromPayment < ActiveRecord::Migration
  def self.up
    remove_column :payments, :accepted
  end

  def self.down
    add_column :payments, :accepted, :boolean, :default => false
  end
end
