class HomeController < ApplicationController
  layout 'rofls'
  def index
    @rofls = Rofl.paginate(:page => params[:page], :per_page => 30, :order => "id desc")
  end

  def random
    ids = Rofl.find(:all, :select => :id)
    @image = Rofl.find(ids[rand(ids.count).to_i].id)
  end
end
