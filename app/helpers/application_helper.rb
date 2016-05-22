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
    return mentions.uniq
  end

  def show_mentions(text, mentions)
    mentions.each do |m|
      text.gsub!(/@#{m.mentioned.username}/i, link_to("@#{m.mentioned.username}", m.mentioned, :class => "stop-propagation mention-link over-comments-link"))
    end
    return text
  end

  def has_favourited(favouritable)
    Favourite.where(:favouritable => favouritable, :favouriter => current_user).count > 0
  end

  def has_reposted_track(track)
    Retrack.where(:reposter => current_user, :track => track).count > 0
  end

  def has_reposted_post(post)
    Repost.where(:reposter => current_user, :post => post).count > 0
  end

  def convert_to_https(url)
    uri = URI.parse(url)
    uri.scheme = "https"
    return uri.to_s
  end
end
