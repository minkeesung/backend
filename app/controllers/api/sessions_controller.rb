class Api::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # protect_from_forgery with: :exception

  def create
    @user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if @user
      render '/api/users/show'
    else
      render json: ["Invalid login credentials"], status: 401
    end
  end

  def destroy
    @user = User.find_by(session_token: params[:user][:session_token])

    if @user
      @user.reset_token
      render json: {}
    else
      render json: ["Nobody signed in"], status: 404
    end
  end
end
