class RemoveVerifiedFromTransfer < ActiveRecord::Migration
  def self.up
    remove_column :transfers, :verified
  end

  def self.down
    add_column :transfers, :verified, :boolean, :default => false
  end
end
