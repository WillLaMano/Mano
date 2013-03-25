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
    case params[:provider]
    when "google"
      @authorization = Google_Auth.new
    when "instagram"
      @authorization = Instagram_Auth.new
    end
    @authorization.user_id=params[:state]
    @authorization.code=params[:code]
    respond_to do |format|
      if @authorization.save
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
    end
    respond_to do |format|
      format.html { redirect_to auth.access_url(current_user.id) } # new.html.erb
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
