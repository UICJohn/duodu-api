class V1::MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:room_id].present? && room = current_user.chat_rooms.find_by(id: params[:room_id])
      @messages = room.messages.page(params[:page])
      current_user.delivery_logs.create( @messages.not_delivered(current_user, room).map { |message| {target: message } } )
    else
      error!({error: 'Bad Request'})
    end
  end
end