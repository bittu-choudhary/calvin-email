class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'slack-ruby-client'
  Slack.configure do |config|
    config.token = ENV['calvin_token']
  end

  # get_message = Slack::RealTime::Client.new
  # get_message.on :message do |data|
  #   # get_message.message user: data.user_id, text: "Do you want to send this email? subject -> #{content.first.strip}, body -> #{content.last.strip}. Type y/n" if state == 1
  #   # state = 2
  #   if (data.text == 'y' || data.text == 'Y')
  #     # CalvinMailer.inform_channel(from_name, from_email, members_emails, content.first.strip, content.last.strip).deliver
  #   elsif (data.text == 'n' || data.text == 'N')
  #     get_message.message channel: data.channel, text: "Email not sent."
  #   else
  #     get_message.message channel: data.channel, text: "Enter correct value."
  #   end
  # end
  # Thread.new do
  #   get_message.start!
  # end

  def create
    data  = OpenStruct.new params
    if data.token != ENV['SLACK_EMAIL_BOT']
      client = Slack::Web::Client.new
      from_name = client.users_info(user: data.user_id).user.profile.real_name if data.user_id
      from_email = client.users_info(user: data.user_id).user.profile.email if data.user_id
      members = client.channels_info(channel: data.channel_id).channel.members.to_a - [data.user_id] if data.channel_id
      members_emails = []
      if !members.blank?
        members.each do |member|
          members_emails << client.users_info(user: member).user.profile.email if client.users_info(user: member).user.profile.email
        end
      end
      content = data.text.split("/text") if data.text
      get_message = Slack::RealTime::Client.new
      if data.command == "/email" && (content.length == 2) && !content.first.blank? && !content.last.blank?
        client.chat_postMessage(channel: data.user_id, text: "Do you want to send this email? subject -> #{content.first.strip}, body -> #{content.last.strip}. Type shoot/nope", as_user: true)
        state = "email_prepared"
        get_message.on :message do |data|
          p data
          if data.channel == "D3GPN9J4X"
            if (data.text.downcase == 'shoot') && (state == "email_prepared")
              CalvinMailer.inform_channel(from_name, from_email, members_emails, content.first.strip, content.last.strip).deliver
            elsif (data.text.downcase == 'nope') && (state == "email_prepared")
              get_message.message channel: data.channel, text: "Email not sent."
              state = nil
            elsif (data.text.downcase == 'shoot') && (state != "email_prepared")
              get_message.message channel: data.channel, text: "Nothing to shoot. Queue a email first."
            else
              get_message.message channel: data.channel, text: "Sorry, i didn't understand that"
            end
          end
        end

        Thread.new do
          get_message.start!
        end

      else
        client.chat_postMessage(channel: data.user_id, text: "Wrong email format.(Follow /email <subject> /text <body>)", as_user: true)
      end
    end
  end
end
