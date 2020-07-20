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

    it 'contains edit button wit appropriate class and type' do
      expect(rendered).to have_tag('button', with: {
                                     class: 'btn-warning', type: 'submit'
                                   })
    end

    it 'contains edit button wit appropriate value' do
      expect(rendered).to match('<i class="fa fa-edit">')
    end
  end
end
