class UserMailer < ActionMailer::Base

  def password(user, password)
    subject = "Welcome to TalkyCloud !"
    mail_params = {:from => "no-reply@talkycloud.com", :to => user.email, :subject => subject}
    @user = user
    @password = password

    mail(mail_params)

  end

  def replied_comment(user, post)
    subject = "Your comment is replied !"
    mail_params = {:from => "no-reply@talkycloud.com", :to => user.email, :subject => subject}
    @user = user
    @post = post

    mail(mail_params)

  end

end
