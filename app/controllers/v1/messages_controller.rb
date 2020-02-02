class V1::MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:room_id].present? && @room = current_user.chat_rooms.find_by(id: params[:room_id])
      @messages = @room.messages.page(params[:page])
      if target_messages = Message.not_delivered(current_user, @room).map { |message| {target: message } }
        current_user.delivery_logs.create(target_messages)
      end
    else
      error!({error: 'Bad Request'})
    end
  end
end