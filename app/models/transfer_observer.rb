class TransferObserver < ActiveRecord::Observer
  def after_create(transfer)
    MiddleMan.worker(:mailer_worker).enq_send_transfer_mail(:arg => transfer.id, :job_key => "transfer_#{transfer.id}_mail",:scheduled_at => Time.now)
  end
end
