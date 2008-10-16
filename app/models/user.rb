require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :bills, :class_name => 'bill', :foreign_key => 'creator_id'
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :payments

  has_many :credits, :class_name => "Debt", :foreign_key => "creditor_id"
  has_many :debts, :class_name => "Debt", :foreign_key => "debitor_id"
  has_many :transfers_to, :class_name => 'Transfer', :foreign_key => 'creditor_id'
  has_many :transfers_from, :class_name => 'Transfer', :foreign_key => 'debitor_id'

  validates_presence_of     :login
  validates_format_of       :login,    :with => /^\w+$/
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  before_create :make_activation_code

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def self.find_by_login_like(login)
    self.find(:all, :conditions => ['users.login LIKE ?', "#{login}%" ])
  end

  def costs_by_category(params = {})
    costs = Hash.new
    options = Hash.new
    params[:from] = self.activated_at if params[:from].blank?
    params[:to] = Time.now if params[:to].blank?

    payments.between(params[:from], params[:to]).closed.each do |payment|
      costs[payment.bill.category.name] = 0 if costs[payment.bill.category.name].blank?
      costs[payment.bill.category.name] += payment.amount
    end
    costs
  end

  protected

  def make_activation_code
    self.activation_code = self.class.make_token
  end


end
