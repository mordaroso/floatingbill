class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.column :bill_id,            :integer
      t.column :user_id,            :integer
      t.column :amount,             :decimal, :precision => 10, :scale => 2
      t.column :payed,              :boolean, :default => false
      t.column :verified,           :boolean, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
