RSpec.describe 'projects/_edit' do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
    assign(:project, project)
    render
  end

  describe 'edit project form' do
    it 'contains project title' do
      expect(rendered).to match(project.title.to_s)
    end

    it 'contains input with appropriate class' do
      expect(rendered).to match("edit-project-form-#{project.id}")
    end

    it 'contains edit button' do
      expect(rendered).to have_tag('input', with: { value: 'Edit', type: 'submit' })
    end

    it 'contains destroy button' do
      expect(rendered).to have_tag('a') do
        with_text 'Delete'
      end
    end
  end
end
