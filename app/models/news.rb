class News

  attr_accessor :type, :id, :text, :time

  def initialize(type, id, text, time)
    self.type = type
    self.id = id
    self.text = text
    self.time = time
  end


  def self.get_all_by_user(user)
    news = Array.new
    for payment in user.payments
      news << News.new('Bill', payment.bill.id, 'Bill created', payment.bill.created_at)
    end
    news.sort_by {|n| n.time}
  end

end
