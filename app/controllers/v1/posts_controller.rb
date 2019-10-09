class V1::PostsController < ApplicationController
  include ApplicationHelper

  respond_to :json

  before_action :authenticate_user!

  def index
    @page = params[:page] || 1
    filters = generate_filters(filters_params.to_h)
    @posts = filters.present? ? Post::Base.search(filters).page(@page) : Post::Base.page(@page)
  end

  def create
    @post = current_user.posts.new(posts_params)
    if @post.save!
      render :show
    else
      error!({error: @post.errors})
    end
  end

  def upload_images
    if @post = current_user.posts.find_by(id: params[:post_id])
      attachment = @post.attachments.attach(params[:attachment]).first
      @post.update_attributes(cover_image_id: attachment.id) if params[:cover_image]
      render :show
    else
      error!({error: 'bad request'})
    end
  end

  private
  def posts_params
    params.require(:post).permit(
      :post_type,
      :title,
      :body, 
      :post_type,
      :tenants,
      :range,
      :livings,
      :rooms,
      :rent,
      :toilets,
      :min_rent, 
      :max_rent, 
      :payment_type,  
      :available_from,

      :has_air_conditioner,
      :has_elevator,
      :has_appliance,
      :has_cook_top,
      :has_furniture,

      location_attributes: [
        :longitude,
        :latitude,
        :address
      ]
    )
  end

  def filters_params
    params.permit(
      :page,
      :filters => [
        :min_rent,
        :max_rent,
        :post_types,
        :has_elevator,
        :has_cook_top,
        :has_furniture,
        :has_appliance,
        :gender,
        :rooms,
        :livings,
        :toilets,
        :city,
        :suburb
      ]
    )
  end
end