require 'rails_helper'

RSpec.describe ChatMessage, type: :model, focus: true do
  it { is_expected.to validate_presence_of :content }
end
