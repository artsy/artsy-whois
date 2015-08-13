class FieldContructor
  attr_accessor :fieldsArray

  def initialize(artsy_user)
    @fieldsArray = [
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
        title: "Location",
        value: "#{artsy_user['city']}",
        short: true
      }
    ]

    add_role_text(artsy_user)
    add_floor(artsy_user)
  end

  def getTeam(artsy_user)
    artsy_user['subteam'] != '--' ? artsy_user['subteam'] : artsy_user['team']
  end

  def add_floor(artsy_user)
    if artsy_user['floor'] == 25 || artsy_user['floor'] == 27
      @fieldsArray.push({
        title: "Floor",
        value: "#{artsy_user['floor']}",
        short: true
        })
    end
  end

  def add_role_text(artsy_user)
    if !artsy_user['role_text'].empty?
      @fieldsArray.insert(1, {
        title: "Role",
        value: "#{artsy_user['role_text']}",
        short: false
        })
    end
  end

end