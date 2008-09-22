class Transfer < ActiveRecord::Base
  belongs_to :debitor,  :class_name => "User" , :foreign_key => "debitor_id"
  belongs_to :creditor,  :class_name => "User" , :foreign_key => "creditor_id"

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :debitor
  validates_presence_of :creditor
  validates_presence_of :currency

  named_scope :open, :conditions => { :verified => false }
  named_scope :closed, :conditions => { :verified => true }

  def validate
    #check amount
    errors.add(:amount, "is negative" ) if amount < 0 unless amount.blank?
  end

  def verfiy
    return if verified
    Debt.save_with_params(:debitor => creditor, :creditor => debitor, :currency => currency, :amount => amount)
    self.verified = true
    self.save!
  end

  def creditor_name
    creditor.login unless creditor.blank?
  end

  def creditor_name=(name)
    self.creditor = User.find_by_login(name)
  end
end

