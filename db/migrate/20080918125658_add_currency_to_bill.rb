class AddCurrencyToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :currency, :string, :limit => 3
  end

  def self.down
    remove_column :bills, :currency
  end
end
