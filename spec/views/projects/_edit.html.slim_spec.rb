RSpec.describe 'projects/_edit' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'projects/edit.html.slim', locals: { project: project }
  end

  describe 'edit project form' do
    it 'contains project title' do
      expect(rendered).to match(project.title.to_s)
    end

    it 'contains input with appropriate class' do
      expect(rendered).to match("edit-project-title-#{project.id}")
    end

    it 'contains edit button with appropriate class and type' do
      expect(rendered).to have_tag('button', with: {
                                     class: 'text-warning', type: 'submit'
                                   })
    end
  end
end
