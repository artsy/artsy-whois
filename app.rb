# app.rb
require 'sinatra'
require 'dotenv'
require 'slack'
require 'json'
require 'httparty'
require 'pp'
require 'csv'

Dotenv.load

class Whois < Sinatra::Base
  post '/' do
    content_type :json

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    client = Slack::Client.new

    subject = params[:text]
    user_name = params[:user_name]

    slack_user = client.users_list['members'].find { |u| u["name"] == subject }

    response = HTTParty.get("#{ENV['TEAM_NAV_API']}members")
    user_list = JSON.parse(response.body)

    artsy_user = user_list.find do |u|
      "#{u['email']}artsymail.com" == slack_user['profile']['email']
    end

    headshot = "#{artsy_user['headshot'][/[^\?]+/]}?raw=true"
    img_url = HTTParty.get headshot
    img_url.request.last_uri.to_s
    puts img_url.request.last_uri.to_s

    attachments = [{
        title: "#{artsy_user['name']}",
        text: "",
        thumb_url: "#{img_url.request.last_uri.to_s}",
        fields: [
          {
            title: "Title",
            value: "#{artsy_user['title']}",
            short: false
          },
          {
            title: "Team",
            value: "#{artsy_user['team']}",
            short: true
          }
        ]
      }]
    args = {
      channel: "@#{user_name}",
      text: "",
      username: "Artsy",
      icon_url: "https://www.artsy.net/images/icon-150.png",
      attachments: attachments.to_json
    }

    client.chat_postMessage args
    status 200
    body ''
  end
end