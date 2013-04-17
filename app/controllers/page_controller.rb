class PageController < ApplicationController
  def feed
    @group = Group.find(params[:group_id])
    puts params
    puts "grp: #{@group}"
    authorize! :manage, @group
    @users = @group.users
    @users.each do |m|
      puts m.name
    end
  end
end
