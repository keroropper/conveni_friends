require 'rails_helper'

RSpec.describe "Evaluations", type: :system do
  let!(:user) { create(:user) }
  before do
    create_list(:user, 25)
    create_list(:recruit, 25, user:)
    15.times { |n| ChatRoom.create(id: n) }
    (2..25).each do |i|
      create(:relation, follower_id: (i + 1), followed_id: user.id, recruit_id: (i - 1))
      Member.create(user_id: user.id, chat_room_id: (i - 1))
      Member.create(user_id: (i + 1), chat_room_id: (i - 1))
      Evaluation.create(evaluator_id: (i + 1), evaluatee_id: user.id, recruit_id: (i - 1), score: 5, feedback: 'ありがとう')
    end
    sign_in(user)
  end

  it 'ページネーションが表示されていること' do
    visit user_evaluations_path(user)
    expect(page).to have_css('.pagination')

    click_link '2'
    expect(page).to have_current_path(user_evaluations_path(user, page: 2))
  end
end
