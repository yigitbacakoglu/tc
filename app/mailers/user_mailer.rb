class UserMailer < ActionMailer::Base

  def password(user, password)
    subject = "Welcome to TalkyCloud !"
    mail_params = {:from => "no-reply@talkycloud.com", :to => user.email, :subject => subject}
    @user = user
    @password = password

    mail(mail_params)

  end

end
