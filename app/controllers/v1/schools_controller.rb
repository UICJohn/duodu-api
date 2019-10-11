class V1::SchoolsController < ApplicationController
  before_action :authenticate_user!
  def index
    @schools = if params[:key].present?
                 School.search params[:key], fields: %i[name py], body_options: { min_score: 0.7 }
               else
                 School.all
               end
  end
end
