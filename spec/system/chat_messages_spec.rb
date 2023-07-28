require 'rails_helper'

RSpec.describe "ChatMessages", type: :system do

  let!(:user) { create(:user) }
  let!(:room) { create(:chat_room).save }
  before do
    sign_in user
    @message = create(:chat_message, user_id: user.id, chat_room_id: room.id)
  end
end
