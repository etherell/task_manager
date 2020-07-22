require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  include_context 'with logged in user with project and task'

  describe '#index' do
    subject(:get_index) { get root_path }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'when request is successful' do
      it 'returns successful status' do
        get_index
        expect(response.status).to eq(200)
      end

      it 'renders index template' do
        get_index
        expect(response.status).to render_template(:index)
      end
    end

    context 'without projects' do
      it 'returns no projects' do
        get_index
        expect(assigns(:projects)).to be_empty
      end
    end

    context 'with 5 projects' do
      let(:number_of_projects) { 5 }
      let!(:user_projects) { create_list(:project, number_of_projects, user: user) }
      let!(:random_projects) { create_list(:project, number_of_projects) }

      before { get_index }

      it 'returns 5 appropriate projects' do
        expect(assigns(:projects)).to match_array(user_projects)
      end

      it 'doesn\'t returns random projects' do
        expect(assigns(:projects)).not_to match_array(random_projects)
      end
    end
  end

  describe '#edit' do
    subject(:get_edit) { get edit_project_path(project, format: :js), xhr: true }

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

      it 'render edit template' do
        get_edit
        expect(response.status).to render_template(:edit)
      end
    end
  end

  describe '#create' do
    subject(:create_project) { post projects_path(project: project_params, format: :js) }

    let(:project_params) { { title: title } }
    let(:title) { 'Test' }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with correct params' do
      let(:flash_message) { 'Project was successfully created.' }

      it_behaves_like 'a correct params response'

      it 'adds new record' do
        expect { create_project }.to change(Project, :count).by(1)
      end

      it 'has correct user and title' do
        create_project
        expect(Project.last.user).to eq(user)
      end

      it 'has correct title' do
        create_project
        expect(Project.last.title).to eq(project_params[:title])
      end
    end

    context 'with short title' do
      let(:title) { '' }
      let(:flash_message) { 'Title is too short (minimum is 3 characters)' }

      it_behaves_like 'an incorrect params response'

      it 'not adds new project' do
        expect { create_project }.to change(Project, :count).by(0)
      end
    end

    context 'with long title' do
      let(:title) { 'a' * 76 }
      let(:flash_message) { 'Title is too long (maximum is 75 characters)' }

      it_behaves_like 'an incorrect params response'

      it 'not adds new project' do
        expect { create_project }.to change(Project, :count).by(0)
      end
    end
  end

  describe '#update' do
    subject(:update_project) do
      patch project_path(project, project: project_params, format: :js)
    end

    let(:project_params) { { title: title } }
    let(:title) { 'Test' }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'with correct params' do
      let(:flash_message) { 'Project was successfully updated.' }
      let!(:title_before) { project.title }

      it_behaves_like 'a correct params response'

      it 'changes record title value' do
        update_project
        expect(project.reload.title).not_to eq(title_before)
      end
    end

    context 'with short title' do
      let(:title) { '' }
      let(:flash_message) { 'Title is too short (minimum is 3 characters)' }

      it_behaves_like 'an incorrect params response'

      it 'not changes title value' do
        expect(project.reload.title).not_to eq(title)
      end
    end

    context 'with long title' do
      let(:title) { 'a' * 76 }
      let(:flash_message) { 'Title is too long (maximum is 75 characters)' }

      it_behaves_like 'an incorrect params response'

      it 'not changes title value' do
        expect(project.reload.title).not_to eq(title)
      end
    end
  end

  describe '#destroy' do
    subject(:destroy_project) { delete project_path(project, format: :js) }

    let!(:project) { create(:project, user: user) }

    context 'with not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context 'with not authorized user' do
      it_behaves_like 'a not authorized error'
    end

    context 'when request is successful' do
      it 'has success status' do
        destroy_project
        expect(response.status).to eq(200)
      end

      it 'adds success flash' do
        destroy_project
        expect(flash[:success]).to eq('Project was successfully deleted.')
      end

      it 'deletes record' do
        expect { destroy_project }.to change(Project, :count).by(-1)
      end
    end

    context 'with invalid params' do
      let(:flash_message) { 'Project wasn\'t deleted.' }

      before do
        allow_any_instance_of(Project).to receive(:destroy).and_return(false)
      end

      it_behaves_like 'an incorrect params response'

      it 'deletes no objects' do
        expect { destroy_project }.not_to change(Project, :count)
      end
    end
  end
end
