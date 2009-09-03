class UploadController < ApplicationController
  before_filter :login, :except => [ :create ]

  def create
    render :not_found unless session[:user_id]
  end
end
