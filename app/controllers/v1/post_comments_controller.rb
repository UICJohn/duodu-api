class V1::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   if (post = Post::Base.find_by(id: params[:id])).present?
  #     @comments = Comment.where(target: post)
  #   else
  #     error!(error: 'bad request')
  #   end
  # end

  def create
    if(post = Post::Base.find_by(id: params[:comment][:post_id])).present?
      if @comment = current_user.comments.create(body: params[:comment][:body], target: post)
        render :show
      else
        error!(error: @comment.errors.full_message)
      end
    else
      error!(error: 'bad request')
    end
  end

  def reply
    if(source_comment = Comment.find_by(id: params[:id])).present?
      @comment = current_user.comments.create(body: params[:comment][:body], target: source_comment)
    else
      error!(error: 'bad request')
    end
  end

  def destroy
    if(comment = current_user.comments.find_by(id: params[:comment][:id])).present?
      comment.sub_comments.destroy_all
      comment.destroy
      success!('deleted')
    else
      error!(error: 'bad request')
    end
  end
end