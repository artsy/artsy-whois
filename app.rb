# app.rb
require 'sinatra'
require 'dotenv'
require 'slack'
require 'json'
require 'httparty'
require 'pp'

Dotenv.load

class WhoIs < Sinatra::Base

  post '/' do
    content_type :json

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    client = Slack::Client.new

    subject = params[:text]
    user = params[:user_name]

    client.users_list['members'].each do |user|
      if user["name"] == subject
        response = HTTParty.get("#{ENV['TEAM_NAV_API']}member?=#{user['profile']['email']}")
        puts "#{ENV['TEAM_NAV_API']}member?=#{user['profile']['email']}"
        puts response.body
        response.body.to_json
      end
    end
  end

end