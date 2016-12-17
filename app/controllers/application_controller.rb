class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # require 'slack-ruby-client'
  # Slack.configure do |config|
  #   config.token = "xoxb-117434645217-EyFfy60fFgqgqLsAS5hZbd0k"
  #   p config.token
  # end

  def create
    p request.POST
    data  =OpenStruct.new params # {"token":"afTHUU0noMmKbAf9gbDkZiqZ","team_id":"T0001","team_domain":"example","channel_id":"C2147483705","channel_name":"test","user_id":"U2147483697","user_name":"Steve","command":"/weather","text":"94070","response_url":"https://hooks.slack.com/commands/1234/5678"}
    p data

    # client = Slack::Web::Client.newß
    # get_message = Slack::RealTime::Client.new
    # get_message.on :message do |data|
    #   content =  data.text.split(" /text ")
    #   if data.command == "/email" && (content.length == 2) && !content.first.blank? && !content.last.blank?
    #
    #   end
    # end
    # Thread.new do
    #   get_message.start!
    # end
  end
end
