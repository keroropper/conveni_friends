require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let!(:recruit) { create(:recruit, user:) }
  let!(:existing_favorite) { create(:favorite, user:, recruit:) }
  it { is_expected.to validate_uniqueness_of(:recruit_id).scoped_to(:user_id) }
end
