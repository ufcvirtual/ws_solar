class TokenAuthenticationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    current_user.reset_authentication_token!

    respond_to do |format|
      format.xml {
        render :status => 200, :xml => { :new_token => { :error => "Success", :auth_token => current_user.authentication_token }}
      }

      format.json {
        render :status => 200, :json => { :new_token => { :error => "Success", :auth_token => current_user.authentication_token } }
      }
    end

  end

  def destroy
    @user = current_user
    @user.authentication_token = nil
    @user.save
    redirect_to edit_user_registration_path(@user)
  end
end