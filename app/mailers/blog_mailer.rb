class BlogMailer < ActionMailer::Base
  default :from => "no-reply@talkycloud.com"
  #TODO
  def contact_mail(contact, store)
    @contact = contact
    to = store.profile.emails.default.address
    bcc = Spree::Config[:default_bcc]
    mail_params = {:from => Spree::Config[:no_reply_from_mail], :to => to, :bcc => bcc, :subject => I18n.translate("you_have_new_message"), :reply_to => contact.email}
    mail(mail_params)
  end

end
