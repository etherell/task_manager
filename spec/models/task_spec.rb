require 'rails_helper'
require 'faker'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }
  let(:object) { task }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:project) }

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

  describe 'project presence' do
    context 'without project' do
      let(:data) { { project: nil } }
      let(:error_message) { 'Project must exist' }

      it_behaves_like 'an object with errors'
    end

    context 'with project' do
      let(:data) { { project: build(:project) } }

      it_behaves_like 'an object without errors'
    end
  end

  describe 'description length' do
    context 'with short description' do
      let(:data) { { description: 'a' } }
      let(:error_message) { 'Description is too short (minimum is 3 characters)' }

      it_behaves_like 'an object with errors'
    end

    context 'with long title' do
      let(:data) { { description: ('a' * 256).to_s } }
      let(:error_message) { 'Description is too long (maximum is 255 characters)' }

      it_behaves_like 'an object with errors'
    end

    context 'with valid description' do
      let(:data) { { description: ('a' * 150).to_s } }

      it_behaves_like 'an object without errors'
    end
  end

  describe 'deadline' do
    context 'without deadline' do
      let(:data) { { deadline: nil } }
      let(:error_message) { 'Deadline can\'t be blank' }

      it_behaves_like 'an object with errors'
    end

    context 'with invalid deadline' do
      let(:data) { { deadline: Time.zone.now.yesterday } }
      let(:error_message) { 'Deadline can\'t be in the past' }

      it_behaves_like 'an object with errors'
    end

    context 'with valid deadline' do
      let(:data) { { deadline: Time.zone.now.tomorrow } }

      it_behaves_like 'an object without errors'
    end
  end

  describe 'position' do
    context 'without position' do
      let(:data) { { position: nil } }
      let(:error_message) { 'Position can\'t be blank' }

      it_behaves_like 'an object with errors'
    end

    context 'with invalid position' do
      let(:project) { create(:project) }
      let(:task) { build(:task, project: project) }
      let(:data) { { position: 1 } }
      let(:error_message) { 'Position has already been taken' }

      it_behaves_like 'an object with errors' do
        before { create(:task, project: project, position: 1) }
      end
    end

    context 'with valid position' do
      let(:data) { { position: 1 } }

      it_behaves_like 'an object without errors'
    end
  end

  describe '#done!' do
    subject(:done!) { task.done! }

    it { expect { done! }.to change(task, :is_done).from(false).to(true) }
  end

  describe '#not_done!' do
    subject(:not_done!) { task.not_done! }

    let(:task) { build(:task, is_done: true) }

    it { expect { not_done! }.to change(task, :is_done).from(true).to(false) }
  end
end
