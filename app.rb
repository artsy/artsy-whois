# app.rb
require 'sinatra'
require 'dotenv'
require 'slack'
require 'json'
require 'httparty'
require 'pp'
require 'csv'
require './fields_constructor.rb'

Dotenv.load

class WhoIs < Sinatra::Base
  post '/' do
    content_type :json

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    client = Slack::Client.new

    subject = params[:text]
    user_name = params[:user_name]

    user = client.users_list['members'].find { |u| user["name"] == subject }

    response = HTTParty.get("#{ENV['TEAM_NAV_API']}member?=#{user['profile']['email']}")
    artsy_user = JSON.parse(response.body)

    attachments = [{
        title: "#{artsy_user['name']}",
        text: "",
        thumb_url: user['profile']['image_192'],
        fields: FieldConstructor.new(artsy_user)
      }]
    args = {
      channel: "@#{user_name}",
      text: "",
      icon_url: "https://www.artsy.net/images/icon-150.png",
      attachments: attachments.to_json
    }
    client.chat_postMessage args

  end
end