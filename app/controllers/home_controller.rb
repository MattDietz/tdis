class HomeController < ApplicationController
  layout 'rofls'
  def index
    @rofls = Rofl.find :all
  end

  def random
    ids = Rofl.find(:all, :select => :id)
    @image = Rofl.find(ids[rand(ids.count).to_i].id)
  end
end
