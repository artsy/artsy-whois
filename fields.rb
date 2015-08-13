class Fields
  attr_accessor :array

  def initialize(artsy_user)
    @array = [
      { title: "Title",
        value: "#{artsy_user['title']}",
        short: false
      },
      { title: "Team",
        value: get_team(artsy_user),
        short: true
      },
      {
        title: "Email",
        value: "#{artsy_user['email']}artsymail.com",
        short: true
      },
      {
        title: "Floor",
        value: get_floor(artsy_user),
        short: true
      }
    ]
  end

  def get_team(artsy_user)
    artsy_user['subteam'] != '--' ? artsy_user['subteam'] : artsy_user['team']
  end

  def get_floor(artsy_user)
    artsy_user['floor'] == '--' ? 'Remote' : artsy_user['floor']
  end

end