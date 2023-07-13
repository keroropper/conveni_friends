require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "Users#show, edit, update" do
    let!(:user) { FactoryBot.create(:user, :perfect_user) }
    let!(:other) { FactoryBot.create(:user, :perfect_user) }
    before do
      sign_in user
    end
    it 'アタッチしている画像と自己紹介文が表示されている' do
      get user_path(user)
      expect(response.body).to match(/kitten.jpg/)
      expect(response.body).to include('初めまして!私の名前はperfectです!')
    end

    it '他のユーザーの編集ページへ行こうとするとホーム画面へリダイレクトすること' do
      get edit_user_path(other)
      expect(response).to redirect_to root_path
    end

    it '他のユーザーのupdateアクションを実行しようとするとホームへリダイレクトすること' do
      other_params = FactoryBot.attributes_for(:user)
      patch user_path(other), params: { user: other_params }
      expect(response).to redirect_to root_path
    end
  end
end
