class V1::OccupationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @occupations = if params[:key].present?
      Occupation.search params[:key], fields: [:name, :py], body_options: { min_score: 0.5 }
    else
      Occupation.all
    end
  end
end