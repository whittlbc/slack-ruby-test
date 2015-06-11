require "slack"

# Configure Slack with your token
def configure_slack
  Slack.configure do |config|
    config.token = "xoxb-6241885424-zuVPcIHi073cmPSGICqNc8zF"
  end
end


# Just some example useful Slack API methods
def example_slack_methods

  # Test that you're correctly authed according to your provided token
  # Returns who you are
  Slack.auth_test


  # Get list of all users on team (Name, Username, UserID, Email)
  Slack.users_list


  # Get list of all accessible DM channels based on who you are
  Slack.im_list


  # Open a IM with someone
  Slack.im_open(user => "userID")


  # Post a message to either a public channel like #general or an DM channel using that channel's ID (found from calling Slack.im_list)
  Slack.chat_postMessage(:channel => "#general", :username => "Reflektive Bot", :text => "Hey from the Reflektive team!")

end


# Get all members of a team and strip out all the useful info for future storage
def get_all_members

  request = Slack.users_list
  raw_members = request["members"]
  all_members = []

  raw_members.each { |member|

    profile = member["profile"]

    member_obj = {
        "username" => member["name"],
        "user_id" => member["id"],
        "name" => profile["real_name"],
        "email" => profile["email"]
    }

    all_members.push(member_obj)
  }

  # save data to DB

end


# Post a new Poll question to every team member separately (could used for anonymous feedback too)
def new_poll

  question = "*How awesome is Manny?*"
  answer1 = "\n1. <https://dry-retreat-2699.herokuapp.com|Freaking Awesome!>"
  answer2 = "\n2. <https://dry-retreat-2699.herokuapp.com|Aweseome>"
  answer3 = "\n3. <https://dry-retreat-2699.herokuapp.com|Okay>"
  answer4 = "\n4. <https://dry-retreat-2699.herokuapp.com|Sucks>"
  answer5 = "\n5. <https://dry-retreat-2699.herokuapp.com|Dude needs to GTFO>"
  poll = question+answer1+answer2+answer3+answer4+answer5

  request = Slack.im_list
  channels_list = request["ims"]

  channels_list.each { |channel|

    Slack.chat_postMessage(:channel => channel["id"], :username => "Poll", :text => poll, :icon_url => "https://dry-retreat-2699.herokuapp.com/images/Reflektive-Icon-1024.png")

  }

end


# Get history for specific DM channel -- Could use polling shortly after sending out company polls and find diffs to...
# ...capture Free Response feedback from users
def get_history(channel_id)

  request = Slack.im_history(:channel => channel_id)
  history = request["messages"]
  latest_message = history[0]
  latest_message_poster_id = latest_message["user"]
  latest_message_text = latest_message["text"]

end


configure_slack()
new_poll()
