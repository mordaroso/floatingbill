class AddCurrencyToDebt < ActiveRecord::Migration
  def self.up
    add_column :debts, :currency, :string, :limit => 3
  end

  def self.down
    remove_column :debts, :currency
  end
end
