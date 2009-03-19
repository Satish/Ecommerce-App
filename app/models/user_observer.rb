class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserMailer.deliver_signup_notification(user, user.store)
  end

  def after_save(user)
    UserMailer.deliver_activation(user, user.store) if user.recently_activated?
  end
  
end
