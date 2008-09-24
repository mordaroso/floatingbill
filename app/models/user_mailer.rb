class UserMailer < ActionMailer::Base
  $url = 'http://floatingbill.net'

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

  def payment_notification(payment)
    setup_email(payment.payer)
    @subject += payment.bill.creator.login
    @subject += ' has created a new bill.'
    @body[:url] = $url + '/bills/#{payment.bill.id}'
    @body[:payment] = payment
  end


  def transfer_notification(transfer)
    setup_email(transfer.creditor)
    @subject += transfer.debitor
    @subject += ' has sent you money.'
    @body[:url] = $url + '/transfers/#{transfer.id}'
    @body[:transfer] = transfer
  end


  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "no_reply@floatingbill.net"
    @subject     = "fb: "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
