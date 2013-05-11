class StoreMailer < ActionMailer::Base

  def bad_ratings(store, post)
    subject = "Alert : Bad Ratings !"
    mail_params = {:from => "no-reply@talkycloud.com", :to => store.email, :subject => subject}
    @store = store
    @post = post
    mail(mail_params)
  end

end
