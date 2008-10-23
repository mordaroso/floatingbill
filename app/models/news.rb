class News

  attr_accessor :type, :object, :verb, :time, :user

  def initialize(type, object, verb, time, user)
    self.type = type
    self.object = object
    self.verb = verb
    self.time = time
    self.user = user
  end


  def self.get_all_by_user(user)
    news = Array.new

    #bills and payments
    for bill in Bill.by_user_id(user.id)
      #created
      news << News.new('bill', bill, 'created', bill.created_at, bill.creator) unless bill.creator == user

      # accepted
      for payment in bill.payments.closed
        news << News.new('bill', bill, 'accepted', payment.accepted_at, payment.payer) unless payment.payer == user
      end

      # closed
      news << News.new('bill', bill, 'closed', bill.created_at, bill.creator) unless bill.closed_at.blank? or bill.creator == user
    end

    #transfer
    for transfer in Transfer.find_all_by_user_id(user.id)
      news << News.new('transfer', transfer, 'created', transfer.created_at, transfer.debitor) unless bill.creator == user
      news << News.new('transfer', transfer, 'verified', transfer.verified_at, transfer.creditor) unless !transfer.verified? || bill.creator == user
    end

    news.sort_by {|n| n.time}
  end

end

