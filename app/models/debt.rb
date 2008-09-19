class Debt < ActiveRecord::Base
  belongs_to :creditor, :class_name => "User" , :foreign_key => "creditor_id"
  belongs_to :debitor, :class_name => "User" , :foreign_key => "debitor_id"

  def self.save_with_params(options = {})
    credit = Debt.find_by_debitor_id_and_creditor_id_and_currency(options[:creditor].id, options[:debitor].id, options[:currency])
    difference = options[:amount]
    unless credit.blank?
      difference -= credit.amount
      if difference < 0
        credit.amount = - difference
        credit.save
      else
        credit.destroy
      end
    end
    if difference > 0
      debt = Debt.find_or_initialize_by_debitor_id_and_creditor_id_and_currency(options[:debitor].id, options[:creditor].id, options[:currency])
      debt.amount = 0 if debt.amount.blank?
      debt.amount += difference
      debt.save
    end
  end
end
