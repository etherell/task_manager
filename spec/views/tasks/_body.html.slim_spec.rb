RSpec.describe 'tasks/_body' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'tasks/body.html.slim', locals: { project: project, task: task }
  end

  describe 'task body partial' do
    it 'contains task status' do
      expect(rendered).to have_tag('div', with: { class: 'task-status' })
    end

    it 'contains done button' do
      expect(rendered).to have_tag('a', with: { class: 'task-done-btn' })
    end

    it 'contains delete button' do
      expect(rendered).to have_tag('a', with: { class: 'delete-task-btn' })
    end

    it 'contains edit button' do
      expect(rendered).to have_tag('a', with: { class: 'edit-task-btn' })
    end

    it 'contains appropriate description' do
      expect(rendered).to match(task.description.to_s)
    end
  end
end
