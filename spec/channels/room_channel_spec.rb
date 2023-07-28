require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let!(:user) { create(:user) }
  let!(:other) { create(:user) }
  let!(:chat_room) { create(:chat_room) }
  before do
    stub_connection current_user: user
  end

  it 'メッセージを保存できること' do
    subscribe room: "#{user.id}_#{chat_room.id}"
    expect(subscription).to be_confirmed
    expect do
      perform :speak, content: "Hello, ActionCable!", current_user_id: user.id, partner_id: other.id, room_id: chat_room.id
    end.to change { ChatMessage.count }.by(1)
  end

  it 'subscribes to the correct room channel' do
    subscribe(room: "#{user.id}_#{chat_room.id}")
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("room_channel_#{user.id}_#{chat_room.id}")
  end
end
