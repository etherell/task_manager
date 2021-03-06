require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:tasks) }
end
