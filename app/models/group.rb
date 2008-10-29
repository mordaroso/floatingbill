class Group < ActiveRecord::Base
  has_many :memberships
  has_many :members, :through => :memberships, :source => :user
  has_many :admins, :through => :memberships, :source => :user, :conditions => 'memberships.admin is not null'
  has_and_belongs_to_many :bills

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :deleted, :if => Proc.new { |u| !u.deleted? }
  validates_format_of :name, :with => /^[\w\s]+$/

  def add_admin(user)
    membership = Membership.find_or_initialize_by_user_id_and_group_id(user.id, id)
    membership.admin = true
    memberships << membership
  end

  def remove_admin(user)
    membership = Membership.find_by_user_id_and_group_id(user.id, id)
    membership.admin = false
    membership.save
  end

  def remove_member(user)
    membership = Membership.find_by_user_id_and_group_id(user.id, id)
    if membership.admin && admins.count == 1
      false
    else
      members.delete(user)
      save
      true
    end
  end

  def delete_group
    self.deleted = true
    self.members = []
    self.save!
  end

  def self.find_all_with_filter(params = {})
    if params[:user_id].blank?
      Group.find(:all, :order => 'name', :conditions => ['deleted is null'])
    else
      Group.find(:all, :include => :memberships, :conditions => ["memberships.user_id = ?",params[:user_id] ])
    end
  end

  def self.find_by_name_like(name)
    self.find(:all, :conditions => ['groups.name LIKE ? and deleted is null', "#{name}%" ])
  end

  #TODO put small values to others
  def costs_by_category(params = {})
    costs = Hash.new
    options = Hash.new
    params[:from] = self.created_at if params[:from].blank?
    params[:to] = Time.now if params[:to].blank?

    bills.between(params[:from], params[:to]).closed.each do |bill|
      for payment in bill.payments
        costs[bill.category.name] = 0 if costs[bill.category.name].blank?
        costs[bill.category.name] += payment.amount
      end
    end
    costs
  end

end
