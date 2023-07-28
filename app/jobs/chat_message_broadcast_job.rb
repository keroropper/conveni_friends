class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, current_user_id, partner_id, room_id)
    data = {
      message: render_chat_message(message),
    }
    # 送信者にブロードキャスト
    ActionCable.server.broadcast("room_channel_#{current_user_id}_#{room_id}", data.merge(isCurrent_user: true))

    # 相手にブロードキャスト
    ActionCable.server.broadcast("room_channel_#{partner_id}_#{room_id}", data.merge(isCurrent_user: false))
  end

  private 

  def render_chat_message(message)
    # ApplicationController.renderer.render partial: 'relations/chat_message', locals: { message: message }
    result = ApplicationController.render_with_signed_in_user(message.user, partial: 'relations/chat_message', locals: { message: message })
    return result
  end
end
