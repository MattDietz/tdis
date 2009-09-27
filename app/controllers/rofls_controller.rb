class RoflsController < ApplicationController
  before_filter :login, :except => [ :index, :show ]

  def new
    @rofl = Rofl.new
  end

  def show
    @rofl = Rofl.find params[:id]
  end

  def index
    redirect_to :controller => :home, :action => :index
  end

  def create
    render :not_found unless session[:user_id]
    @rofl = Rofl.create! params[:rofl]
    redirect_to @rofl
  end
end
