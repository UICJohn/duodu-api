class V1::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    unless (@post = Post::Base.find_by(id: params[:post_id])).present?
      error!(error: 'bad request')
    end
  end

  def create
    if(@post = Post::Base.find_by(id: params[:comment][:post_id])).present?

      comment = current_user.comments.new(body: params[:comment][:body], target: @post)

      comment.save ? (render :index) : error!(error: comment.errors.full_message)

    else
      error!(error: 'bad request')
    end
  end

  def reply
    if source_comment = Comment.find_by(id: params[:id])

      comment = current_user.comments.new(
                  body: params[:comment][:body],
                  target: source_comment
                )

      if comment.save && @post = comment.root
        render :index
      else
        error!(error: comment.errors.full_message)
      end

    else
      error!(error: 'bad request')
    end
  end

  def destroy
    if(comment = current_user.comments.find_by(id: params[:id])).present?
      # comment.sub_comments.destroy_all
      comment.destroy
      success!('deleted')
    else
      error!(error: 'bad request')
    end
  end
end