class Payment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :payer, :class_name => "User" ,:foreign_key => "user_id"

  named_scope :open, :conditions => { :accepted => false }

  before_destroy :reset_debt

  def accept
    return if accepted
    Debt.save_with_params(:debitor => payer, :creditor => bill.creator, :currency => bill.currency, :amount => amount)
    puts 'count: ' + bill.payments.open.count.to_s
    if bill.payments.open.count == 1
      bill.closed = true
      bill.save!
    end
    self.accepted = true
    self.save!
  end

  def reset_debt
    if self.accepted and bill.creator != payer
      Debt.save_with_params(:debitor => bill.creator, :creditor => payer, :currency => bill.currency, :amount => amount)
    end
  end
end
