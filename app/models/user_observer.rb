class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #MiddleMan.worker(:mailer_worker).enq_send_signup_mail(:arg => user.id, :job_key => "signup_#{user.id}_mail",:scheduled_at => Time.now)
  end

  def after_save(user)
    #MiddleMan.worker(:mailer_worker).enq_send_signup_mail(:arg => user.id, :job_key => "activation_#{user.id}_mail",:scheduled_at => Time.now) if user.recently_activated?
  end
end
