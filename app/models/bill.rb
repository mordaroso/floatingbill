class Bill < ActiveRecord::Base
  has_many :payments
  has_many :payers, :through => :payments, :class_name => 'User'
  belongs_to :category
  belongs_to :creator, :class_name => 'User'
  has_and_belongs_to_many :groups

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :category_name
  validates_presence_of :name
  validates_presence_of :creator
  validates_presence_of :currency

  attr_accessor :user_ids, :group_ids

  named_scope :by_payer, lambda { |*args| {:include => :payments, :conditions => ['payments.user_id = ?', args.first]} }

  named_scope :open, :conditions => { :closed => false }
  named_scope :closed, :conditions => { :closed => true }

  before_save :set_payments
  before_destroy :reset_payments

  def validate
    #check amount
    errors.add(:amount, "is negative" ) if amount < 0 unless amount.blank?

    #check payer_names
    if payments.count == 0
      if user_ids.blank? and group_ids.blank?
        errors.add(:payers, "are not set" )
      else
        payer_error = false

        unless user_ids.blank?
          for user_id in user_ids
            #check if user exists
            user = User.find(user_id)
            if user.blank?
              errors.add(user_id, "is not a valid user id" )
              payer_error = true
            end
          end
        end

        unless group_ids.blank?
          for group_id in group_ids
            #check if user exists
            group = Group.find(group_id)
            if group.blank?
              errors.add(group_id, "is not a valid group id" )
              payer_error = true
            end
          end
        end

        errors.add(:payers, "are not correct" ) unless !payer_error
      end
    end
  end

  def category_name
    category.name unless category.blank?
  end

  def category_name=(name)
    self.category = Category.find_or_initialize_by_name(name)
  end

  private

  def set_payments
    user_ids = Array.new if user_ids.blank?
    group_ids = Array.new if group_ids.blank?
    users, groups = get_all_payers
    for user in users
      payment = Payment.find_or_initialize_by_user_id_and_bill_id(user.id, id)
      payment.amount = self.amount / (users.length)
      if user.id == creator_id
        payment.accepted = true
        self.closed = true if users.length == 1
      end
      payments << payment
    end
    for group in groups
      self.groups << group
    end
  end

  def get_all_payers
    payers = Array.new
    groups = Array.new
    unless user_ids.blank?
      for user_id in user_ids
        payers << User.find(user_id)
      end
    end
    unless group_ids.blank?
      for group_id in group_ids
        group = Group.find(group_id)
        groups << group
        payers.concat group.members
      end
    end
    [payers.uniq, groups.uniq]
  end


  def reset_payments
    for payment in payments
      payment.destroy
    end
  end
end
