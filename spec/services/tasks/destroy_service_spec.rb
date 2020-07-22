require 'rails_helper'

RSpec.describe Tasks::DestroyService do
  subject(:service_call) { described_class.call(project, task) }

  let(:user) { create(:user) }
  let(:project) { create(:project_with_tasks, user: user) }
  let!(:task) { project.tasks.first }
  let!(:second_task) { project.tasks.second }

  describe '#call' do
    context 'when project and task are correctly set' do
      it 'deletes task' do
        expect { service_call }.to change(Task, :count).by(-1)
      end

      it 'changes tasks positions' do
        service_call
        expect(second_task.reload.position).to eq(1)
      end
    end

    context 'when task is not destroyed' do
      before do
        allow_any_instance_of(Task)
          .to receive(:destroy)
          .and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns false' do
        expect(service_call).to eq(false)
      end
    end
  end

  describe '#reassign_task_positions' do
    let!(:tasks_ids_before) { project.tasks.ids }
    let(:new_positions_arr) { [] }

    before { service_call }

    context 'when tasks reassigned' do
      it 'doesn\'t match tasks ids before' do
        expect(project.reload.tasks.ids).not_to match_array(tasks_ids_before)
      end

      it 'project tasks ids doesn\'t contains deleted task id' do
        expect(project.reload.tasks.ids).not_to include(task.id)
      end

      it 'reassign tasks positions' do
        project.reload.tasks.each do |project_task|
          new_positions_arr << project_task.position
        end
        expect(new_positions_arr).to match_array(1..(project.tasks.length))
      end
    end
  end
end
