class V1::CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = current_user.comments
  end

end