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
      @events[user.name]=user.google.get_current_events
    end
    @markers = ActiveSupport::JSON.encode(@users.map do |user|
      google = user.google
      foursquare = user.foursquare.foursquare_client
      checkin = foursquare.user_checkins(:limit => 1)["items"][0]
      description = "#{user.name} last checked into #{checkin["venue"]["name"]}"
      loc = google.get_current_location
      {"lat"=> loc["latitude"],"sidebar"=>user.name, "lng"=>loc["longitude"],"title"=>user.name, "description"=>description}
    end)

    respond_to do |format|
      format.html
    end
  end
end
