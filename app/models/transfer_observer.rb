class TransferObserver < ActiveRecord::Observer
  def after_create(transfer)
    UserMailer.deliver_transfer_notification(transfer)
  end
end
