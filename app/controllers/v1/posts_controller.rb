class V1::PostsController < ApplicationController
  include ApplicationHelper
  respond_to :json

  before_action :authenticate_user!, except: [:index]
  before_action :set_params_name, only: [:create]

  def index
    @page = params[:page] || 1
    filters = generate_filters(filters_params.to_h)
    @posts = filters.present? ? Post::Base.search(filters).page(@page) : Post::Base.page(@page)
  end

  def create
    @post = current_user.posts.new(self.send(@params_name))
    if @post.save!
      render :show
    else
      error!(error: @post.errors)
    end
  end

  def upload_images
    if (@post = current_user.posts.find_by(id: params[:post_id]))
      attachment = @post.attachments.attach(params[:attachment]).first
      @post.update_attributes(cover_image_id: attachment.id) if params[:cover_image]
      render :show
    else
      error!(error: 'bad request')
    end
  end

  private

  def set_params_name
    @param_name = if %i[0 1].include?(params[:post_type])
      "house_post_params"
    elsif params[:post_type] == 2
      "housemate_post_params"
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
