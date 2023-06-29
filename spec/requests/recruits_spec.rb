require 'rails_helper'
RSpec.describe "Recruits", type: :request do
  describe "GET /recruits" do
    let(:user) { FactoryBot.create(:user) }
    before do
      sign_in(user)
    end

    it "#new" do
      get new_recruit_path
      expect(response).to have_http_status "200"
    end
  end
end
