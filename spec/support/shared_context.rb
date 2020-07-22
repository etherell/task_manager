RSpec.shared_context 'with logged in user with project and task' do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, user: user, project: project) }

  before do
    sign_in user
  end
end
