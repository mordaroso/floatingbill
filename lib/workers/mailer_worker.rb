class MailerWorker < BackgrounDRb::MetaWorker
  set_worker_name :mailer_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end

  def send_payment_mail(payment_id)
    payment = Payment.find(payment_id)
    begin
      UserMailer.deliver_payment_notification(payment, payment.bill)
      logger.info "mail for payment #{payment.id} sucessfully sent"
      persistent_job.finish!
    rescue => bang
      persistent_job.release_job
      logger.error "send mail for payment #{payment.id} failed: #{bang}"
    end
  end

  def send_transfer_mail(transfer_id)
    transfer = Transfer.find(payment_id)
    begin
      UserMailer.deliver_transfer_notification(transfer)
      logger.info "mail for transfer #{transfer.id} sucessfully sent"
      persistent_job.finish!
    rescue => bang
      persistent_job.release_job
      logger.error "send mail for transfer #{transfer.id} failed: #{bang}"
    end
  end

  def send_signup_mail(user_id)
    user = User.find(user_id)
    begin
      UserMailer.deliver_signup_notification(user)
      logger.info "mail for signup #{user.login} sucessfully sent"
      persistent_job.finish!
    rescue => bang
      persistent_job.release_job
      logger.error "send mail for user #{transfer.login} failed: #{bang}"
    end
  end

  def send_activation_mail(user_id)
    user = User.find(user_id)
    begin
      UserMailer.deliver_activation(user)
      logger.info "mail for activation #{user.login} sucessfully sent"
      persistent_job.finish!
    rescue => bang
      persistent_job.release_job
      logger.error "send mail for activation #{transfer.login} failed: #{bang}"
    end
  end


end
