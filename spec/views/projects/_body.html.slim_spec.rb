RSpec.describe 'projects/_body' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'projects/body.html.slim', locals: { project: project }
  end

  describe 'project partial' do
    it 'contains delete button' do
      expect(rendered).to have_tag('a', with: { class: 'delete-btn' })
    end

    it 'contains edit button' do
      expect(rendered).to have_tag('a', with: { class: 'edit-btn' })
    end

    it 'contains appropriate title' do
      expect(rendered).to match(project.title.to_s)
    end
  end
end
