require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "Users#show" do
    let!(:user) { FactoryBot.create(:user, :perfect_user) }
    before do
      sign_in user
    end
    it 'アタッチしている画像と自己紹介文が表示されている' do
      get user_path(user)
      expect(response.body).to match(/kitten.jpg/)
      expect(response.body).to include('初めまして!私の名前はperfectです!')
    end
  end
end
