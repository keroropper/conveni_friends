require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  it { is_expected.to validate_presence_of :score }
  it { is_expected.to validate_presence_of :feedback }
  it { is_expected.to validate_presence_of :recruit_id }
  it { is_expected.to validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
end
