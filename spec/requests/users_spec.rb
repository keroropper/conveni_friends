require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /dummy" do
    it "returns http success" do
      get "/users/dummy"
    end
  end

end
