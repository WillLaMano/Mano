class PageController < ApplicationController
  def feed
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @users = @group.users
  end

  def current_status
    @group = Group.find(params[:id])
    @users = @group.users
    @events = {}
    @users.each do |user|
      ugoogle = user.google
      unless ugoogle.nil?
        user_events = user.google.get_current_events
        @events[user.name] = user_events unless user_events.empty?
      end
    end
    
    @markers = ActiveSupport::JSON.encode(@users.map do |user|
      markers = {"sidebar" => user.name}
      google = user.google
      foursquare = user.foursquare
      if foursquare
        checkin = foursquare.get_last_checkin
        # FIXME: 4sq and glat would not necessarily be the same location
        description = "#{user.name} last checked into #{checkin["venue"]["name"]}" unless checkin.nil?
        markers["description"] = description
      end
      if google
        loc = google.get_current_location
        markers["lat"] = loc["latitude"] unless loc.nil?
        markers["lng"] = loc["longitude"] unless loc.nil?
      end
      markers
    end)

    respond_to do |format|
      format.html
    end
  end
end
