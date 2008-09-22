class Bill < ActiveRecord::Base
  has_many :payments
  has_many :payers, :through => :payments, :class_name => 'User'
  belongs_to :category
  belongs_to :creator, :class_name => 'User'

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :category_name
  validates_presence_of :name
  validates_presence_of :creator
  validates_presence_of :currency

  attr_accessor :payer_names, :group_names

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
      if payer_names.blank? and group_names.blank?
        errors.add(:payers, "are not set" )
      else
        payer_error = false

        unless payer_names.blank?
          payer_names.sort!
          payer_names.each_index do |i|
            payer_name = payer_names.at(i)
            #check if user exists
            user = User.find_by_login(payer_name)
            if user.blank?
              errors.add(payer_name, "is not a user" )
              payer_error = true

              #check if user is twice in list
            elsif payer_names.at(i+1) == payer_name
              errors.add(payer_name, "is twice in list" )
              payer_error = true
            end
          end
        end

        unless group_names.blank?
          group_names.sort!
          group_names.each_index do |i|
            group_name = group_names.at(i)
            #check if user exists
            group = Group.find_by_name(group_name)
            if group.blank?
              errors.add(group_name, "is not a group" )
              payer_error = true

              #check if user is twice in list
            elsif group_names.at(i+1) == group_name
              errors.add(group_name, "is twice in list" )
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
    payer_names = Array.new if payer_names.blank?
    group_names = Array.new if group_names.blank?
    users = get_all_payers
    for user in users
      payment = Payment.find_or_initialize_by_user_id_and_bill_id(user.id, id)
      payment.amount = self.amount / (users.length)
      if user.id == creator_id
        payment.accepted = true
        self.closed = true if users.length == 1
      end
      payments << payment
    end
  end

  def get_all_payers
    payers = Array.new
    unless payer_names.blank?
      for payer_name in payer_names
        payers << User.find_by_login(payer_name)
      end
    end
    unless group_names.blank?
      for group_name in group_names
        payers.concat Group.find_by_name(group_name).members
      end
    end
    payers.uniq
  end


  def reset_payments
    for payment in payments
      payment.destroy
    end
  end
end

