class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'slack-ruby-client'
  Slack.configure do |config|
    config.token = ENV['calvin_token']
    p config.token
  end

  def create
    # CalvinMailer.inform_channel("bittu", "bittu@moldedbits.com", ["a@a.com", "b@b.com"], "hello from console").deliver
    # p request.GET
    # p params
    data  =OpenStruct.new params #    {"token"=>"afTHUU0noMmKbAf9gbDkZiqZ", "team_id"=>"T1WPV6FM4", "team_domain"=>"our-notebook", "channel_id"=>"D3GPN9J4X", "channel_name"=>"directmessage", "user_id"=>"U1WPTHM52", "user_name"=>"bittu.choudhary", "command"=>"/email", "text"=>"hello", "response_url"=>"https://hooks.slack.com/commands/T1WPV6FM4/118211630021/kJlP1NrPKuyhqvVA79bnltgI"}
    # p data

    client = Slack::Web::Client.new
    from_name = client.users_info(user: data.user_id).user.profile.real_name
    from_email = client.users_info(user: data.user_id).user.profile.email
    members = client.channels_info(channel: data.channel_id).channel.members.to_a - [data.user_id]
    members_emails = []
    members.each do |member|
      members_emails << client.users_info(user: member).user.profile.email if client.users_info(user: member).user.profile.email
    end
    # get_message = Slack::RealTime::Client.new
    # get_message.on :message do |data|
      content =  data.text.split(" /text ")
      if data.command == "/email" && (content.length == 2) && !content.first.blank? && !content.last.blank?
        CalvinMailer.inform_channel(from_name, from_email, members_emails, content.first, content.last).deliver
      end
    # end
    Thread.new do
      get_message.start!
    end
  end
end
