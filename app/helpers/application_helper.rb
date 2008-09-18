# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def meta_description
    "Organize your bills with your friends and housemates"
  end

  def meta_keywords
    "bill, payment, money, organize, floating, bill, the floating bill"
  end

  def currency_sign(key)
    $currencies[key]
  end

end
