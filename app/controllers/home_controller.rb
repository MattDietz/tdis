class HomeController < ApplicationController
  def index
    @rofls = Rofl.find :all
  end
end
