class News

  attr_accessor :object, :verb, :time, :user, :text

  def initialize(object, verb, time, user, text)
    self.object = object
    self.verb = verb
    self.time = time
    self.user = user
    self.text = text
  end


  def self.get_all_by_user(user)
    news = Array.new

    #bills and payments
    for bill in Bill.by_user_id(user.id)
      news += get_all_by_bill(bill, :user => user)
    end

    #transfer
    for transfer in Transfer.find_all_by_user_id(user.id)
      news += get_all_by_transfer(transfer, :user => user)
    end

    news.sort_by {|n| n.time}
  end

  def self.get_all_by_bill(bill, options = {})
    news = Array.new

    #created
    if options[:user].blank? or bill.creator != options[:user]
      news << News.new(bill, 'created', bill.created_at, bill.creator, bill.description)
    end

    # accepted
    for payment in bill.payments.closed
      if options[:user].blank? or (payment.payer != options[:user] and bill.creator == payment.payer)
        news << News.new(bill, 'accepted', payment.accepted_at, payment.payer, bill.description)
      end
    end

    # closed
    if bill.closed? and (options[:user].blank? or bill.creator != options[:user])
      news << News.new(bill, 'closed', bill.closed_at, bill.creator, bill.description)
    end

    news.sort_by {|n| n.time}
  end

  def self.get_all_by_transfer(transfer, options = {})
    news = Array.new

    #created
    if options[:user].blank? or transfer.debitor != options[:user]
      news << News.new(transfer, 'created', transfer.created_at, transfer.debitor, '')
    end

    #verified
    if transfer.verified? and (options[:user].blank? or transfer.debitor == options[:user])
      news << News.new(transfer, 'verified', transfer.verified_at, transfer.creditor, '')
    end

    news.sort_by {|n| n.time}
  end

end
