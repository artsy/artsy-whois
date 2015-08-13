# app.rb
require 'sinatra'
require 'dotenv'
require 'slack'
require 'json'
require 'httparty'
require 'pp'
require 'csv'

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

    client.users_list['members'].each do |user|
      if user["name"] == subject

        response = HTTParty.get("#{ENV['TEAM_NAV_API']}member?=#{user['profile']['email']}")
        artsy_user = JSON.parse(response.body)

        attachments = [{
            title: "#{artsy_user['name']}",
            text: "",
            thumb_url: user['profile']['image_192'],
            fields: [
              {
                title: "Role",
                value: "#{artsy_user['role']}",
                short: true
              },
              {
                title: "Team",
                value: "#{artsy_user['practice']}",
                short: true
              }
            ]
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
  end
end

class ArtsyUsers

  def initialize
    @csv = CSV.open(ENV['TEAM_CSV'], :headers => true).map { |x| x.to_h }
    @users = @csv.to_json
    puts @users
  end

  def get(attr)

  end

end