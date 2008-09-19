class Payment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :payer, :class_name => "User" ,:foreign_key => "user_id"

  named_scope :open, :conditions => { :accepted => false }


  def accept
    return if accepted
    self.accepted = true
    Debt.save_with_params(:debitor => payer, :creditor => bill.creator, :currency => bill.currency, :amount => amount)
    self.save
  end
end
