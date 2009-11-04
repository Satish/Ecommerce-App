class UserMailer < ActionMailer::Base
  
  def signup_notification(user, store)
    setup_email(user, store, get_activation_link(user, store), 'Please activate your new account')
  end
  
  def activation(user, store)
    setup_email(user, store, "http://www.#{ store.domain }/login", 'Your account has been activated!')
  end

  def resend_activation(user, store =  user.store)
    setup_email(user, store, get_activation_link(user, store), 'Please activate your account')
  end

  protected ################################

  def setup_email(user, store, url, default_subject = nil)
    email_template(store)
    recipients      user.email
    from            @email_template.from
    cc              @email_template.cc unless @email_template.cc.blank?
    bcc             @email_template.bcc unless @email_template.bcc.blank?
    subject         @email_template.subject.blank? ? "[www.#{ store.domain }] #{ default_subject }" : @email_template.render_subject({ :user => UserDrop.new(user), :store  => StoreDrop.new(store) }.stringify_keys!)
    body            @email_template.render({
                                            :user   => UserDrop.new(user),
                                            :store  => StoreDrop.new(store),
                                            :url    => url }.stringify_keys!)
  end

  def email_template(store)
    @email_template ||= store.email_templates.find_by_name(template)
  end

  def get_activation_link(user, store)
    @activation_link ||= activate_url(:activation_code => user.activation_code, :host => "www.#{ store.domain }")
  end

end