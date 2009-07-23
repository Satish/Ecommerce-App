module Admin::MailSettingsHelper

  def options_for_mail_auth_type
    MAIL_AUTH
  end

  def options_for_secure_connection_type
    SECURE_CONNECTION_TYPES
  end

end
