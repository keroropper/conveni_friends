require 'rails_helper'

RSpec.describe Applicant, type: :model do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let!(:recruit) { create(:recruit, user:) }
  let!(:existing_applicant) { create(:applicant, user: other, recruit:) }
  it { is_expected.to validate_uniqueness_of(:recruit_id).scoped_to(:user_id) }

  it '自分の投稿には応募できないこと' do
    invalid_applicant = Applicant.new(user_id: user.id, recruit_id: recruit.id)
    expect(invalid_applicant.valid?).to  be_falsey
  end
end
