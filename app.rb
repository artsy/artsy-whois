# app.rb
require 'sinatra'
require 'dotenv'
require 'slack'
require 'json'
require 'httparty'
require 'pp'
require 'csv'
require 'uri'
require './fields.rb'

Dotenv.load

class Whois < Sinatra::Base

  post '/' do
    content_type :json

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Client.new

    username = params[:text]
    requester = params[:user_name]

    response = HTTParty.get("#{ENV['TEAM_NAV_API']}members")
    user_list = JSON.parse(response.body)

    slack_user = find_slack_profile(username)
    artsy_user = find_artsy_user(slack_user)

    return "Could not find user!" if slack_user.nil? || artsy_user.nil?

    headshot = artsy_user['headshot'].empty? ? slack_user['profile']['image_192'] : artsy_user['headshot']

    attachments = [{
        title: "#{artsy_user['name']}",
        text: "",
        thumb_url: "#{embedly_url(headshot)}",
        fields: Fields.new(artsy_user).array
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

  def find_slack_profile(username)
    puts @client
    slack_user = @client.users_list['members'].find do |u|
      u["name"] == username
    end
  end

  def find_artsy_user(slack_user)
    artsy_user = user_list.find do |u|
      "#{u['email']}artsymail.com" == slack_user['profile']['email']
    end
  end

  def embedly_url(img)
    unless img.index('gravatar')
      uri = URI::HTTP.build(
        host: "i.embed.ly",
        path: "/1/display/crop",
        query: URI.encode_www_form({
          url: img,
          width: 200,
          height: 200,
          quality: 90,
          grow: false,
          key: ENV['EMBEDLY_KEY']
        })
      )
      uri
    end
  end
end