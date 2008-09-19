module BillsHelper

  def add_payment_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :payers, :partial => 'payment'
    end
  end
end
