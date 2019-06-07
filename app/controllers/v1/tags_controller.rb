class V1::TagsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @tags = if params[:category].present? && catrgory = Category.find_by(name: params[:catrgory])
      Tag.where(catrgory_id: catrgory.id)
    else
      Tag.all
    end
  end
end