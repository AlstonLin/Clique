class NotificationsController < ApplicationController
  def index
    @notifications = []
    # FIXME: This is really inefficient, but Rail's update_all is being called before the select for some reason
    current_user.notifications.each do |n|
      if !n.read
        # Something wierd happened to this; Just delete it
        if n.notifiable == nil
          n.destroy
        else
          @notifications << n
          n.read = true
          n.save
        end
      end
    end
  end
end
