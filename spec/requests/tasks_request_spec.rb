require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  include_context 'with logged in user with project and task'

  describe '#create' do
    subject(:create_task) do
      post project_tasks_path(project, task: task_params, format: :js)
    end

    let(:task_params) { { description: description, deadline: deadline } }
    let(:description) { 'test' }
    let(:deadline) { Time.zone.now.tomorrow }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with correct params' do
      let(:flash_message) { 'Task was successfully created.' }

      it_behaves_like 'a correct params response'

      it 'adds new record' do
        expect { create_task }.to change(Task, :count).by(1)
      end

      it 'has correct user and description' do
        create_task
        expect(Task.last.user).to eq(user)
      end

      it 'has correct description' do
        create_task
        expect(Task.last.description).to eq(task_params[:description])
      end
    end

    context 'with short description' do
      let(:description) { '' }
      let(:flash_message) { 'Description is too short (minimum is 3 characters)' }

      it_behaves_like 'an incorrect params response'
    end

    context 'with long description' do
      let(:description) { 'a' * 256 }
      let(:flash_message) { 'Description is too long (maximum is 255 characters)' }

      it_behaves_like 'an incorrect params response'
    end

    context 'with deadline in the past' do
      let(:deadline) { Time.zone.now.yesterday }
      let(:flash_message) { 'Deadline can\'t be in the past' }

      it_behaves_like 'an incorrect params response'
    end

    context 'without deadline' do
      let(:deadline) { nil }
      let(:flash_message) { 'Deadline can\'t be blank' }

      it_behaves_like 'an incorrect params response'
    end
  end

  describe '#update' do
    subject(:update_task) do
      patch project_task_path(project, task, task: task_params, format: :js)
    end

    let(:task_params) { { description: 'Test', deadline: Time.zone.now.tomorrow.round } }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'with correct params' do
      let(:flash_message) { 'Task was successfully updated.' }

      it 'changes description' do
        update_task
        task.reload
        expect(task.description).to eq(task_params[:description])
      end

      it 'changes deadline' do
        update_task
        task.reload
        expect(task.deadline.round).to eq(task_params[:deadline])
      end

      it_behaves_like 'a correct params response'
    end

    context 'with short description' do
      let(:task_params) { { description: '' } }
      let(:flash_message) { 'Description is too short (minimum is 3 characters)' }

      it_behaves_like 'an incorrect params response'
    end

    context 'with long description' do
      let(:task_params) { { description: ('a' * 256).to_s } }
      let(:flash_message) { 'Description is too long (maximum is 255 characters)' }

      it_behaves_like 'an incorrect params response'
    end

    context 'without deadline' do
      let(:task_params) { { deadline: nil } }
      let(:flash_message) { 'Deadline can\'t be blank' }

      it_behaves_like 'an incorrect params response'
    end

    context 'with deadline in the past' do
      let(:task_params) { { deadline: Time.zone.now.yesterday } }
      let(:flash_message) { 'Deadline can\'t be in the past' }

      it_behaves_like 'an incorrect params response'
    end
  end

  describe '#edit' do
    subject(:get_edit) do
      get edit_project_task_path(project, task, format: :js), xhr: true
    end

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'when request is successful' do
      it 'returns successful status' do
        get_edit
        expect(response.status).to eq(200)
      end

      it 'renders edit template' do
        get_edit
        expect(response.status).to render_template(:edit)
      end
    end
  end

  describe '#new' do
    subject(:get_new) { get new_project_task_path(project, format: :js), xhr: true }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'when request is successful' do
      it 'returns successful status' do
        get_new
        expect(response.status).to eq(200)
      end

      it 'renders edit template' do
        get_new
        expect(response.status).to render_template(:new)
      end
    end
  end

  describe '#destroy' do
    subject(:destroy_task) { delete project_task_path(project, task, format: :js) }

    let!(:task) { create(:task, project: project, user: user) }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'when request is successful' do
      it 'has success status' do
        destroy_task
        expect(response.status).to eq(200)
      end

      it 'adds success flash' do
        destroy_task
        expect(flash[:success]).to eq('Task was successfully deleted.')
      end

      it 'deletes record' do
        expect { destroy_task }.to change(Task, :count).by(-1)
      end
    end

    context 'with invalid params' do
      let(:flash_message) { 'Task wasn\'t deleted' }

      before do
        allow_any_instance_of(Tasks::DestroyService).to receive(:call).and_return(false)
      end

      it_behaves_like 'an incorrect params response'

      it 'deletes no objects' do
        expect { destroy_task }.not_to change(Task, :count)
      end
    end
  end

  describe '#done' do
    subject(:done_task) do
      patch done_project_task_path(project, task, format: :js)
    end

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'when tak is not done' do
      let(:flash_message) { 'Task status was changed.' }

      it 'changes is_done to true' do
        done_task
        task.reload
        expect(task.is_done).to eq(true)
      end

      it_behaves_like 'a correct params response'
    end

    context 'when task is done' do
      let(:flash_message) { 'Task status was changed.' }
      let(:task) { create(:task, user: user, project: project, is_done: true) }

      it 'changes is_done to false' do
        done_task
        task.reload
        expect(task.is_done).to eq(false)
      end

      it_behaves_like 'a correct params response'
    end
  end

  describe '#move' do
    subject(:move_task) do
      patch move_project_task_path(target_project, task,
                                   target_tasks_ids: target_tasks_ids,
                                   source_tasks_ids: source_tasks_ids,
                                   format: :js)
    end

    let(:source_project) { create(:project_with_tasks, user: user) }
    let(:target_project) { create(:project_with_tasks, user: user) }
    let(:source_tasks_ids) { source_project.tasks.ids[0...-1].to_s }
    let(:moved_id) { source_project.tasks.ids.pop }
    let(:target_tasks_ids) { target_project.tasks.ids.unshift(moved_id).to_s }
    let(:task) { Task.find(moved_id) }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'when task moves from one project to another' do
      let(:flash_message) { 'Task was successfully moved.' }

      it_behaves_like 'a correct params response'

      it 'changes target project tasks positions' do
        move_task
        target_project.reload
        expect(target_project.tasks.ids).to match_array(JSON.parse(target_tasks_ids))
      end

      it 'changes source project tasks positions' do
        move_task
        source_project.reload
        expect(source_project.tasks.ids).to match_array(JSON.parse(source_tasks_ids))
      end
    end

    context 'when task wasn\'t moved.' do
      let(:flash_message) { 'Task wasn\'t moved.' }

      before do
        allow_any_instance_of(Tasks::MoveService).to receive(:call).and_return(false)
      end

      it_behaves_like 'an incorrect params response'
    end
  end
end
