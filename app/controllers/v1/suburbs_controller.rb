class V1::SuburbsController < ApplicationController
  before_action :authenticate_user!

  def index
    @suburbs = if params[:region].present?
                 Region::City.find_by(name: params[:region]).try(:suburbs) || []
               else
                 Region::Suburb.all
               end
  end
end
