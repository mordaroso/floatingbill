class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.integer :debitor_id
      t.integer :creditor_id
      t.decimal :amount,   :precision => 10, :scale => 2
      t.string  :currency, :limit => 3
      t.boolean :verified, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :transfers
  end
end
