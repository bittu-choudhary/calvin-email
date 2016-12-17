class CalvinMailer < ApplicationMailer

  def inform_channel(from_name, from_email, receivers, subject, content)
    @from_name = from_name
    @content = content
    p from_name
    p from_email
    p receivers
    p subject
    p content
    # default :from => "#{from_name} <#{from_email}>"
    # mail to: receivers, subject: subject, :from => "#{from_name} <#{from_email}>"
  end
end
