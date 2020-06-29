require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  shared_examples 'a not authorized error' do
    let(:another_user) { create(:user) }

    before do
      sign_out user
      sign_in another_user
      subject
    end

    it 'renders unauthorized partial' do 
      expect(response).to render_template(partial: 'shared/_unauthorized')
    end

    it 'has unauthorized status' do 
      expect(response.status).to eq(401)
    end

    it 'sets correct flash' do 
      expect(controller).to set_flash[:error].to('You are not authorized to access this page.')
    end
  end

  shared_examples 'a correct params response' do
    before { subject }

    it "has success status" do
      expect(response.status).to eq(200)
    end

    it "adds success flash" do
      expect(flash[:success]).to eq(flash_message)
    end
  end

  shared_examples 'an incorrect params response' do
    before { subject }

    it "has unprocessable entity status" do
      expect(response.status).to eq(422)
    end

    it "adds error flash" do
      expect(flash[:error]).to eq(flash_message)
    end
  end

  shared_examples 'a not logged in error' do
    before do
      sign_out user
      subject
    end

    it 'redirects to log in page' do
      expect(response.status).to eq(302)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns appropriate flash' do
      expect(flash[:error]).to eq('Please, log in or sign up to continue')
    end
  end

  describe '#index' do
    subject { get root_path }

    context 'not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context "successful request" do
      it "returns successful status" do
        subject
        expect(response.status).to eq(200)
      end

      it "render index template" do
        subject
        expect(response.status).to render_template(:index)
      end
    end

    context "without projects" do
      it "returns no projects" do
        subject
        expect(assigns(:projects)).to be_empty
      end
    end

    context "with 5 projects" do
      let(:number_of_projects) { 5 }
      let!(:user_projects) { create_list(:project, number_of_projects, user: user) }
      let!(:random_projects) { create_list(:project, number_of_projects) }
      
      it "returns 5 projects" do
        subject
        expect(assigns(:projects)).to match_array(user_projects)
        expect(assigns(:projects)).to_not match_array(random_projects)
      end
    end
  end

  describe "#edit" do
    subject { get edit_project_path(project, format: :js), xhr: true }

    context 'not logged in user' do
      it_behaves_like 'a not logged in error'
    end
    
    context "not authorized user" do
      it_behaves_like "a not authorized error"
    end

    context "successful request" do
      it "returns successful status" do
        subject
        expect(response.status).to eq(200)
      end

      it "render edit template" do
        subject
        expect(response.status).to render_template(:edit)
      end
    end
  end

  describe "#create" do
    subject { post projects_path(project: project_params, format: :js) }
    let(:project_params) { { title: "Test" } } 

    context 'not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context "correct params are passed" do
      let(:flash_message) { "Project was successfully created." }

      it_behaves_like 'a correct params response'

      it "adds new record" do
        expect{ subject }.to change(Project, :count).by(1)
      end
  
      it "has correct user and title" do
        subject
        expect(Project.last.user).to eq(user)
        expect(Project.last.title).to eq(project_params[:title])
      end
    end

    context "incorrect params are passed" do
      let(:project_params) { { title: "" } }
      let(:flash_message) { "Title is too short (minimum is 3 characters)" }

      it_behaves_like 'an incorrect params response'

      it "not adds new project" do
        expect{ subject }.to change(Project, :count).by(0)  
      end
    end
  end

  describe "#update" do
    subject { patch project_path(project, project: project_params, format: :js) }
    let(:project_params) { { title: "Test" } }

    context 'not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context "not authorized user" do
      it_behaves_like "a not authorized error"
    end

    context "correct params are passed" do
      let(:flash_message) { "Project was successfully updated."}
      let!(:title_before) { project.title }

      it_behaves_like 'a correct params response'

      it "changes record title value" do
        subject
        expect(project.reload.title).not_to eq(title_before)
      end
    end

    context "incorrect params are passed" do
      let(:project_params) { { title: "" } }
      let(:flash_message) { "Title is too short (minimum is 3 characters)" }
      
      it_behaves_like 'an incorrect params response'
    end
  end

  describe "#destroy" do
    subject { delete project_path(project, format: :js) }
    let!(:project) { create(:project, user: user) }
    
    context 'not logged in user' do
      it_behaves_like 'a not logged in error'
    end

    context "not authorized user" do
      it_behaves_like "a not authorized error"
    end

    context "successful request" do
      it "has success status" do
        subject
        expect(response.status).to eq(200)
      end

      it "adds success flash" do
        subject
        expect(flash[:success]).to eq("Project was successfully deleted.")
      end

      it "deletes record" do
        expect{ subject }.to change(Project, :count).by(-1)
      end
    end
  end

end
