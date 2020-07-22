RSpec.describe 'projects/_new' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'projects/new.html.slim'
  end

  describe 'crete project form' do
    it 'contains input to create new project' do
      expect(rendered).to have_tag('input', with: { class: 'add-project-title' })
    end

    it 'contains add new project button' do
      expect(rendered).to have_tag('input', with: { value: 'Add new project' })
    end
  end
end
