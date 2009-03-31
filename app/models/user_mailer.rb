class UserMailer < ActionMailer::Base
  $url = 'http://floatingbill.com'

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'

    @body[:url]  = $url + "/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = $url
  end

  def payment_notification(payment, bill)
    setup_email(payment.payer)
    @subject += bill.creator.login
    @subject += ' has created a new bill.'
    @body[:url] = $url + '/bills/' + bill.id.to_s
    @body[:payment] = payment
    @body[:bill] = bill
  end


  def transfer_notification(transfer)
    setup_email(transfer.creditor)
    @subject += transfer.debitor.login
    @subject += ' has sent you money.'
    @body[:url] = $url + '/transfers/' + transfer.id.to_s
    @body[:transfer] = transfer
    @body[:debitor] = transfer.debitor
  end


  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "info@floatingbill.com"
    @subject     = "fb: "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
