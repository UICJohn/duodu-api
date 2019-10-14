class V1::PostsController < ApplicationController
  include ApplicationHelper
  respond_to :json

  before_action :authenticate_user!, except: [:index]
  before_action :preprocess_params, only: [:create]

  def index
    @page = params[:page] || 1
    filters = generate_filters(filters_params.to_h)
    @posts = filters.present? ? Post::Base.search(filters).page(@page) : Post::Base.page(@page)
  end

  def create
    @post = "Post::#{@post_type}".constantize.new(self.send(@params_name))
    @post.user = current_user
    if @post.save!
      render :show
    else
      error!(error: @post.errors)
    end
  end

  def upload_images    
    if (params[:attachment].present? && @post = current_user.posts.find_by(id: params[:post_id]))
      if attachment = @post.attachments.attach(params[:attachment])
        @post.active = true
        @post.cover_image_id = attachment.id if params[:cover_image]
        @post.save
      end
      render :show
    else
      error!(error: 'bad request')
    end
  end

  private

  def preprocess_params
    @post_type = if %i[take_house share_house house_mate].include?(params[:post][:post_type].to_sym)
      params[:post][:post_type].camelize
    end

    @params_name = if @post_type.present?
      params[:post][:post_type] == 'house_mate' ? "housemate_post_params" : "house_post_params"
    else
      error!(error: 'bad request')
    end
  end

  def house_post_params
    params.require(:post).permit(
      :post_type,
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
      :tenants_gender,
      location_attributes: %i[
        longitude
        latitude
        address
      ]
    )
  end

  def housemate_post_params
    params.require(:post).permit(
      :post_type,
      :title,
      :body,
      :available_from,
      :tenants,
      :has_pets,
      :min_rent,
      :max_rent,
      :area_ids,
      :tenants_gender,
      :smoke_allow,
      :has_air_conditioner,
      :has_elevator,
      :has_appliance,
      :has_cook_top,
      :has_furniture,
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
