# app.rb
require 'sinatra'
require 'slack-ruby-client'
require 'dotenv'
Dotenv.load

class WhoIs < Sinatra::Base

  post '/' do
    Slack::Web::Client.config do |config|
      config.token = ENV['SLACK_API_TOKEN']
      config.user_agent = 'Slack Ruby Client/1.0'
      puts config.token
    end

    @client = Slack::Web::Client.new

    subject = params[:text]
    user = params[:user_name]

    @client.users.list.members.each do |user|
      if user["name"] == subject
        puts user
      end
    end

  end

end