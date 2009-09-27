class HomeController < ApplicationController
  layout 'rofls'
  def index
    @rofls = Rofl.find :all
  end
end
