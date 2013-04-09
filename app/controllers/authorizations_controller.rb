class AuthorizationsController < ApplicationController
  before_filter :require_user

  # GET /authorizations
  # GET /authorizations.json
  def index
    @authorizations = current_user.authorizations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authorizations }
    end
  end

  # GET /authorizations/1
  # GET /authorizations/1.json
  def show
    @authorization = Authorization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authorization }
    end
  end

  # GET /authorizations/new
  # GET /authorizations/new.json
  def new
    @services = Authorization.services.delete_if{|a|
      current_user.authorizations.any?{|b|
        b.auth_type.downcase==a.downcase
      }}
    respond_to do |format|
      if !@services.empty?
        format.html # show.html.erb
      else
        format.html{redirect_to authorizations_url, alert: "You can't create any more services"}
      end
    end
  end

  def callback

    @services = Authorization.services.delete_if{|a|
      current_user.authorizations.any?{|b|
        b.auth_type.downcase==a.downcase
      }}
    case params[:provider]
    when "google"
      @authorization = Google_Auth.new
    when "instagram"
      @authorization = Instagram_Auth.new
    when "twitter"
      @authorization = Twitter_Auth.new
      @authorization.request_token({:request_token=>session[:request_token],
                                   :request_secret => session[:request_secret]
                                  })
    end
    @authorization.user=current_user
    @authorization.params=params
    respond_to do |format|
      if @authorization.save!
        format.html { redirect_to authorizations_url, notice: 'Authorization was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # GET /authorizations/1/edit
  def edit
    @authorization = Authorization.find(params[:id])
  end

  # POST /authorizations
  # POST /authorizations.json
  def create
    case params[:provider].downcase
    when "google"
      auth=Google_Auth.new
    when "instagram"
      auth=Instagram_Auth.new
    when "twitter"
      auth=Twitter_Auth.new
      request_token=auth.request_token
      session[:request_token]=request_token.token
      session[:request_secret]=request_token.secret
    end
    respond_to do |format|
      format.html { redirect_to auth.access_url} 
      format.json { render json: @authorization }
    end
  end

  # PUT /authorizations/1
  # PUT /authorizations/1.json
  def update
    @authorization = Authorization.find(params[:id])

    respond_to do |format|
      if @authorization.update_attributes(params[:authorization])
        format.html { redirect_to @authorization, notice: 'Authorization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authorization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorizations/1
  # DELETE /authorizations/1.json
  def destroy
    @authorization = Authorization.find(params[:id])
    @authorization.destroy

    respond_to do |format|
      format.html { redirect_to authorizations_url }
      format.json { head :no_content }
    end
  end
end
