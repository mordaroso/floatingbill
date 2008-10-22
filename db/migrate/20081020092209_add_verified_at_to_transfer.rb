class AddVerifiedAtToTransfer < ActiveRecord::Migration
  def self.up
    add_column :transfers, :verified_at, :datetime
  end

  def self.down
    remove_column :transfers, :verified_at
  end
end
