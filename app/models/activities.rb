class Activities

  attr_accessor :object, :verb, :time, :user, :text

  def initialize(object, verb, time, user, text)
    self.object = object
    self.verb = verb
    self.time = time
    self.user = user
    self.text = text
  end

  #OPTIMIZE add limit
  def self.get_all_by_user(user)
    activities = Array.new

    #bills and payments
    for bill in Bill.by_user_id(user.id)
      activities += get_all_by_bill(bill, :user => user)
    end

    #transfer
    for transfer in Transfer.by_user_id(user.id)
      activities += get_all_by_transfer(transfer, :user => user)
    end

    activities.sort_by {|n| n.time}
  end

  def self.get_all_by_bill(bill, options = {})
    activities = Array.new

    #created
    if options[:user].blank? or bill.creator != options[:user]
      activities << Activities.new(bill, 'created', bill.created_at, bill.creator, bill.description)
    end

    # accepted
    for payment in bill.payments.closed
      if (options[:user].blank? or payment.payer != options[:user]) and bill.creator != payment.payer
        activities << Activities.new(bill, 'accepted', payment.accepted_at, payment.payer, bill.description)
      end
    end

    # closed
    if bill.closed? and (options[:user].blank? or bill.creator != options[:user])
      activities << Activities.new(bill, 'closed', bill.closed_at, bill.creator, bill.description)
    end

    activities.sort_by {|n| n.time}
  end

  def self.get_all_by_transfer(transfer, options = {})
    activities = Array.new

    #created
    if options[:user].blank? or transfer.debitor != options[:user]
      activities << Activities.new(transfer, 'created', transfer.created_at, transfer.debitor, '')
    end

    #verified
    if transfer.verified? and (options[:user].blank? or transfer.debitor == options[:user])
      activities << Activities.new(transfer, 'verified', transfer.verified_at, transfer.creditor, '')
    end

    activities.sort_by {|n| n.time}
  end

end
