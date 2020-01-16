class V1::ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def fetch_room
    if params[:message_to].present? && (user = User.find_by(id: params[:message_to]))
      room = ChatRoom.private_room_for(current_user, user)
      render json: { room: room }
    else
      error!({error: 'No receiver provided!'})
    end
  end  
end