class SessionsController < ApplicationController

  skip_before_action :authorize

  def new
    redirect_to root_url if signed_in?
  end

  def create
    user = User.where('lower(email) = ?', params[:email].try(:strip).try(:downcase)).take
    if user && user.authenticate(params[:password])
      sign_in user, params[:remember_me]
      redirect_back_or root_url
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def refresh
    render nothing: true
  end

end
