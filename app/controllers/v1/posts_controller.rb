class V1::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    # @post = Post.search "apples", where: {in_stock: true},  page: (params[:page] || 1), per_page: 20
    # if current_user.posts.where()
    filters = %w(city province title body property_id country address 
      suburb lon lat range min_rent max_rent rent rent_type available_from 
      livings rooms toilets).map{ |key| [key, params[key]] if params[key].present? }.compact.to_h
    @posts = Post.search( "#{params[:keyword] || '*'}", where: filters, page: (params[:page] || 0), per_page: 10, order: {created_at: :desc, _score: :desc})

  end

  def create
    @post = current_user.posts.new(posts_params)
    if @post.save
      FetchPostLocationWorker.perform_async(@post.id)
      render :show
    else
      error!({error: @post.errors})
    end
  end

  def upload_images
    if @post = Post.find_by(id: params[:post_id])
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
      :address, 
      :range,
      :livings,
      :rooms,
      :rent,
      :toilets,
      :min_rent, 
      :max_rent, 
      :payment_type, 
      :rent_type, 
      :available_from,
      :has_sofa,
      :has_bed,
      :has_air_conditioner,
      :has_elevator,
      :has_washing_machine,
      :has_cook_top,
      :has_fridge,
      :lat,
      :lon
    )
  end
end