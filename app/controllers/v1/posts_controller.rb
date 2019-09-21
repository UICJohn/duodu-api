class V1::PostsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :set_filters

  def index
    @page = params[:page] || 1
    @posts = @filters.present? ? Post.where(@filters).page(@page) : Post.page(@page)
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
      :lease_type, 
      :available_from,
      :has_sofa,
      :has_bed,
      :has_air_conditioner,
      :has_elevator,
      :has_washing_machine,
      :has_cook_top,
      :has_fridge,
      location_attributes: [
        :longitude,
        :latitude,
        :name,
        :address
      ]
    )
  end

  def set_filters
    @filters = {}
  end
end