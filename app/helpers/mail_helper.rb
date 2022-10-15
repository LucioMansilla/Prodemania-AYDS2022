# frozen_string_literal: true

require 'mail'
module MailHelper
  Mail.defaults do
    delivery_method :smtp, {
      address: 'smtp.gmail.com',
      port: 587,
      user_name: 'luciomansillaztw@gmail.com',
      password: ENV['SECRET_APP_CODE'],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end

  def send_email_recovery(mail_user, token, string_token, user_name)
    template = File.read('app/views/players/emails/email_change_password.erb')
    mail = Mail.new
    mail do |m|
      m.from     'luciomansillaztw@gmail.com'
      m.to       mail_user
      m.subject  'Recuperación de contraseña'
      m.html_part = template.gsub('{{token}}', token).gsub('{{string_token}}', string_token).gsub('{{name}}',
                                                                                                  user_name)
    end
    mail.deliver!
  end

  def register_email_successfull(mail_user, user_name)
    template = File.read('app/views/players/emails/emailer.erb')
    mail = Mail.new
    mail do |m|
      m.from 'PRODEMANIA'
      m.to mail_user
      m.subject 'Bienvenido a PRODE'
      m.html_part = template.gsub('{{name}}', user_name)
    end
    mail.deliver
  end

  def generate_random_password(length)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...length).map { o[rand(o.length)] }.join
  end

  def email_update_successfull(mail_user, user_name)
    template = File.read('app/views/players/password_update.erb')
    mail = Mail.new
    mail do |m|
      m.from    'prodemania@gmail.com'
      m.to      mail_user
      m.subject 'Actualización de contraseña'
      m.html_part = template.gsub('{{name}}', user_name)
    end
  end
end
