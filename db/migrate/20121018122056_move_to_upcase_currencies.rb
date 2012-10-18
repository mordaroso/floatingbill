class MoveToUpcaseCurrencies < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      user.update_attribute(:default_currency, user.default_currency.upcase)
    end

    Bill.all.each do |bill|
      bill.update_attribute(:currency, bill.currency.upcase)
    end

    Transfer.all.each do |transfer|
      transfer.update_attribute(:currency, transfer.currency.upcase)
    end
  end

  def self.down
    User.all.each do |user|
      user.update_attribute(:default_currency, user.default_currency.downcase)
    end

    Bill.all.each do |bill|
      bill.update_attribute(:currency, bill.currency.downcase)
    end

    Transfer.all.each do |transfer|
      transfer.update_attribute(:currency, transfer.currency.downcase)
    end
  end
end
