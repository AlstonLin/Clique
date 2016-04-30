module ApplicationHelper
  def generate_mentions(text, mentionable)
    # Scrapes all words with @ and finds the user
    mentioned_users = []
    text.scan(/\@\w+/).each do |w|
      result = User.where("lower(username) =?", w[1..-1].downcase).first
      if result != nil
        mentioned_users << result
      end
    end
    # Creates a mention for each mentioned user
    mentions = []
    mentioned_users.each do |u|
      mention = Mention.new
      mention.mentionable = mentionable
      mention.mentioned = u
      mention.save
      mentions << mention
    end
    return mentions
  end

  def show_mentions(text, mentions)
    mentions.each do |m|
      text.gsub!(/@#{m.mentioned.username}/i, link_to("@#{m.mentioned.username}", m.mentioned, :class => "stop-propagation mention-link"))
    end
    return text
  end
end
