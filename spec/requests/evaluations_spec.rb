require 'rails_helper'

RSpec.describe "Evaluations", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }
  let(:recruit) { FactoryBot.create(:recruit, user: other) }
  let!(:relation)  { FactoryBot.create(:relation, follower_id: other.id, followed_id: user.id, recruit_id: recruit.id) }
  let!(:chat_room) { FactoryBot.create(:chat_room) }
  before do
    Member.create(user_id: user.id, chat_room_id: chat_room.id)
    Member.create(user_id: other.id, chat_room_id: chat_room.id)
    sign_in(user)
  end
  describe "GET /create" do
    it "ユーザーの評価ができること/評価しあったら関係性がリセットされること" do
      expect do
        post user_evaluations_path(other), params: { evaluation: { evaluator_id: user.id, score: 5, feedback: 'ありがとう', recruit_id: recruit.id } }
      end.to change { other.evaluations.count }.by(1)
      sign_out user
      sign_in other
      expect do
        post user_evaluations_path(user), params: { evaluation: { evaluator_id: other.id, score: 5, feedback: 'ありがとう', recruit_id: recruit.id } }
      end.to change { Relation.count }.by(-1).and change { Member.count }.by(-2).and change { ChatRoom.count }.by(-1)
    end
  end
end
