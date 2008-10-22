class AddAcceptedAtToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :accepted_at, :datetime
  end

  def self.down
    remove_column :payments, :accepted_at
  end
end
