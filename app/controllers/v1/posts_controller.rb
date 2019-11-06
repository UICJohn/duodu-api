class V1::PostsController < ApplicationController
  include ApplicationHelper
  respond_to :json

  before_action :authenticate_user!, except: [:index]
  before_action :preprocess_params, only: [:create]

  def index
    @page = params[:page] || 1
    filters = generate_filters(filters_params.to_h)
    @posts = filters.present? ? Post::Base.search(filters).page(@page) : Post::Base.active.page(@page).order('created_at DESC')
  end

  def create
    @post = "Post::#{@post_type}".constantize.new(send(@params_name))
    @post.user = current_user
    if @post.save
      render :show
    else
      error!(error: @post.errors)
    end
  end

  def upload_images
    if params[:attachment].present? && (@post = current_user.posts.find_by(id: params[:post_id]))
      if @post.images.attach(params[:attachment])
        @post.cover_image_id = @post.images.last.id if params[:cover_image]
        @post.save
      end
      render :show
    else
      error!(error: 'bad request')
    end
  end

  private

  def preprocess_params
    @params_name = if params[:post][:type].present? && %i[take_house share_house house_mate].include?(params[:post][:type].to_sym)
                     @post_type = params[:post][:type].camelize
                     params[:post][:type] == 'house_mate' ? 'housemate_post_params' : 'house_post_params'
                   else
                     error!(error: 'bad request')
                   end
  end

  def house_post_params
    params.require(:post).permit(
      :title,
      :body,
      :rooms,
      :rent,
      :livings,
      :toilets,
      :payment_type,
      :available_from,
      :has_furniture,
      :has_appliance,
      :has_network,
      :property_type,
      :has_air_conditioner,
      :has_elevator,
      :has_cook_top,
      :pets_allow,
      :smoke_allow,
      :tenants,
      :tenants_gender,
      location_attributes: %i[
        name
        address
        longitude
        latitude
      ]
    )
  end

  def housemate_post_params
    params.require(:post).permit(
      :title,
      :body,
      :available_from,
      :tenants,
      :smoker,
      :has_pets,
      :min_rent,
      :max_rent,
      :locations_attributes,
      :tenants_gender,
      :smoke_allow,
      :smoker,
      :has_air_conditioner,
      :has_furniture,
      :has_elevator,
      :has_cook_top,
      :has_appliance,
      :has_network,
      locations_attributes: %i[
        name
        address
        longitude
        latitude
      ]
    )
  end

  def filters_params
    params.permit(
      :page,
      filters: %i[
        min_rent
        max_rent
        post_types
        has_elevator
        has_cook_top
        has_furniture
        has_appliance
        gender
        rooms
        livings
        toilets
        city
        suburb
      ]
    )
  end
end
