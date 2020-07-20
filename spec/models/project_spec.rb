require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build(:project) }

  it { is_expected.to belong_to(:user) }

  shared_examples 'an object with errors' do
    it 'returns appropriate error message' do
      project.update(data)
      expect(project.errors.to_a).to include(error_message)
    end
  end

  shared_examples 'an object without errors' do
    it "doesn't return errors" do
      project.update(data)
      expect(project.errors.to_a).to be_empty
    end
  end

  describe 'user presence' do
    context 'without user' do
      let(:data) { { user: nil } }
      let(:error_message) { 'User must exist' }

      it_behaves_like 'an object with errors'
    end

    context 'with user' do
      let(:data) { { user: build(:user) } }

      it_behaves_like 'an object without errors'
    end
  end

  describe 'title length' do
    context 'with short title' do
      let(:data) { { title: 'a' } }
      let(:error_message) { 'Title is too short (minimum is 3 characters)' }

      it_behaves_like 'an object with errors'
    end

    context 'with long title' do
      let(:data) { { title: ('a' * 76).to_s } }
      let(:error_message) { 'Title is too long (maximum is 75 characters)' }

      it_behaves_like 'an object with errors'
    end

    context 'with valid title' do
      let(:data) { { title: ('a' * 25).to_s } }

      it_behaves_like 'an object without errors'
    end
  end
end
