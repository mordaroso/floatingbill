class PaymentObserver < ActiveRecord::Observer
  def after_create(payment)
    #MiddleMan.worker(:mailer_worker).enq_send_payment_mail(:arg => payment.id, :job_key => "payment_#{payment.id}_mail",:scheduled_at => Time.now) unless payment.bill.creator == payment.payer
  end
end
