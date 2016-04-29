class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def comment_form_id(commentable)
    return "#{commentable.class.name}-comment-form#{commentable.id}"
  end
  helper_method :comment_form_id

  def is_following(following, user = nil)
    if user == nil
      user = current_user
    end
    # TODO: Make this more efficient?
    user.following.each do |f|
      if f.following == following
        return true
      end
    end
    return false
  end
  helper_method :is_following

  def get_top(num)
    # TODO: There's probably a more efficient way of doing this
    top = User.where(:id => Follow.group(:following_id).order("count(*) desc").limit(num).count.keys)
    # If there is not enough followers to fill the list, add fill it with people with none
    if top.count < num
      top = top + User.all
      top = top.select{ |t| t != current_user }.uniq.first(num)
    end
    return top
  end

  # def get_top_tracks(num)
  #   # TODO: There's probably a more efficient way of doing this
  #   top = Track.where(:id => Follow.group(:following_id).order("count(*) desc").limit(num).count.keys)
  #   # If there is not enough followers to fill the list, add fill it with people with none
  #   if top.count < num
  #     top = top + User.all
  #     top = top.select{ |t| t != current_user }.uniq.first(num)
  #   end
  #   return top
  # end
end
