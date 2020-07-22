require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build(:project) }
  let(:object) { project }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:tasks) }

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

  describe '#last_task_position' do
    subject(:last_position) { project.last_task_position }

    context 'without tasks' do
      it { expect(last_position).to be_nil }
    end

    context 'with tasks' do
      let(:tasks_quantity) { 10 }
      let(:project) { create(:project_with_tasks, tasks_count: tasks_quantity) }

      it { expect(last_position).to eq(tasks_quantity) }
    end
  end
end
