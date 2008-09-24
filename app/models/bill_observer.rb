class BillObserver < ActiveRecord::Observer
  def after_create(bill)
    for payment in bill.payments
      UserMailer.deliver_payment_notification(payment) unless payment.payer == bill.creator
    end
  end

end
