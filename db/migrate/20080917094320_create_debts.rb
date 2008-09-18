class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      t.integer :creditor_id
      t.integer :debitor_id
      t.decimal :amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :debts
  end
end
