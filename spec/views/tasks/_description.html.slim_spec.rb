RSpec.describe 'tasks/_description' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'tasks/edit.html.slim', locals: { project: project, task: task }
  end

  describe 'description partial' do
    it 'contains appropriate task description' do
      expect(rendered).to match(task.description)
    end
  end
end
