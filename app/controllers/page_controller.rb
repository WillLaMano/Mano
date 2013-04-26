class PageController < ApplicationController
  def feed
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @users = @group.users
  end
end
