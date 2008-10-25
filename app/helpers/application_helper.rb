# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def meta_description
    "Organize your bills with your friends and housemates"
  end

  def meta_keywords
    "bill, payment, money, organize, floating, bill, the floating bill"
  end

  def rss_url(user)
    formatted_feed_user_url(user, :rss, :rss_hash => user.rss_hash)
  end

  def generate_url_by_object(object)
    case object.class.name
    when 'Bill'
      bill_url(object)
    when 'Transfer'
      transfer_url(object)
    end
  end

end
