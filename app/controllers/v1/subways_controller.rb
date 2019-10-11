class V1::SubwaysController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:region].present? && (region = Region::Base.find_by(name: params[:region]))
      @subways = Subway.find_by_region(region)
    else
      error!({ error: 'bad request' }, 400)
    end
  end
end
