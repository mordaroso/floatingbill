class Transfer < ActiveRecord::Base
  belongs_to :debitor,  :class_name => "User" , :foreign_key => "debitor_id"
  belongs_to :creditor,  :class_name => "User" , :foreign_key => "creditor_id"

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :debitor
  validates_presence_of :creditor
  validates_presence_of :currency
  validates_inclusion_of :currency, :in => CurrencySystem::CURRENCY_NAMES

  named_scope :open, :conditions => { :verified_at => nil }
  named_scope :closed, :conditions => [ "transfers.verified_at is not null" ]
  named_scope :by_user_id, lambda { |*args| {:conditions => ["creditor_id = :user_id or debitor_id = :user_id" , {:user_id => args.first}] } }

  before_destroy :reset_debt

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :amount, :creditor_name, :currency

  def validate
    #check amount
    errors.add(:amount, "is negative" ) if amount < 0 unless amount.blank?
    #check self
    errors.add(:creditor, "cant be yourself") if debitor == creditor
  end

  def verified?
    verified_at != nil
  end

  def verfiy
    return if verified?
    Debt.save_with_params(:debitor => creditor, :creditor => debitor, :currency => currency, :amount => amount)
    self.verified_at = Time.now
    self.save!
  end

  def creditor_name
    creditor.login unless creditor.blank?
  end

  def creditor_name=(name)
    self.creditor = User.find_by_login(name)
  end

  def reset_debt
    if self.verified?
      Debt.save_with_params(:debitor => debitor, :creditor => creditor, :currency => currency, :amount => amount)
    end
  end
end
