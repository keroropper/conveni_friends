class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "room_channel_#{params['room']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    obj = ChatMessage.create! content: data['content'], user_id: current_user.id, chat_room_id: data['room_id']
    current_user_id = current_user.id
    partner_id = data['partner_id']
    room_id = data['room_id']
    ChatMessageBroadcastJob.perform_later(obj, current_user_id, partner_id, room_id)
  end
end
