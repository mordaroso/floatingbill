class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.column :category_id,        :integer
      t.column :amount,       :decimal, :precision => 10, :scale => 2
      t.column :description,        :text
      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
