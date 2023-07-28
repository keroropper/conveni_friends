require 'rails_helper'

RSpec.describe "ChatRooms", type: :request do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:recruit) { create(:recruit, user:) }
  before do
    Applicant.create(user_id: other.id, recruit_id: recruit.id)
    sign_in user
  end
  it 'マッチングが成功すると、そのユーザーとのチャットルームが作成されること' do
    initial_count = ChatRoom.count
    post user_relations_path(other, recruit_id: recruit.id)
    expect(ChatRoom.count).to eq(initial_count + 1)

    room_members = Member.where(chat_room_id: ChatRoom.first.id).map(&:user_id)
    expect(room_members).to include(user.id)
    expect(room_members).to include(other.id)
  end
end
