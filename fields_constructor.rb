class FieldContructor

  def initialize(artsy_user)
    fieldsArray = [
      { title: "Title",
        value: "#{artsy_user['title']}",
        short: false
      },
      { title: "Team",
        value: getTeam(artsy_user),
        short: true
      },
      {
        title: "Email",
        value: "#{artsy_user['email']}artsymail.com",
        short: true
      },
      {
        title: "Floor",
        value: getFloor(artsy_user),
        short: true
      }
    ]
  end

  def getTeam(artsy_user)
    artsy_user['subteam'] != '--' ? artsy_user['subteam'] : artsy_user['team']
  end

  def getFloor(artsy_user)
    artsy_user['floor'] == '--' ? 'Remote' : artsy_user['floor']
  end

end