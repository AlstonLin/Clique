class NotificationsController < ApplicationController
  def index
    @notifications = []
    # FIXME: This is really inefficient, but Rail's update_all is being called before the select for some reason
    current_user.notifications.each do |n|
      if !n.read
        @notifications << n
        n.read = true
        n.save
      end
    end
  end
end
