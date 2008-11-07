class Payment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :payer, :class_name => "User" ,:foreign_key => "user_id"

  named_scope :open, :conditions => { :accepted_at => nil }
  named_scope :closed, :conditions => ["payments.accepted_at is not null" ]
  named_scope :between, lambda { |*args| {:conditions => ['payments.created_at between ? and ?', args.first, args.last] } }
  named_scope :by_user_id, lambda { |*args| {:include => :bill, :conditions => ['payments.user_id = ? or bills.creator_id = ?', args.first, args.first]} }

  before_destroy :reset_debt

  def accepted?
    accepted_at != nil
  end

  def accept
    return if accepted?
    Debt.save_with_params(:debitor => payer, :creditor => bill.creator, :currency => bill.currency, :amount => amount)
    if bill.payments.open.count == 1
      bill.closed = true
      bill.save!
    end
    self.accepted_at = Time.now
    self.save!
  end

  def reset_debt
    if self.accepted? and bill.creator != payer
      Debt.save_with_params(:debitor => bill.creator, :creditor => payer, :currency => bill.currency, :amount => amount)
    end
  end
end
