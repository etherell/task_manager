RSpec.describe 'tasks/_edit' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'tasks/edit.html.slim', locals: { project: project, task: task }
  end

  describe 'edit task form' do
    it 'contains form with appropriate class and type' do
      expect(rendered).to have_tag('form', with: {
                                     class: 'edit-task-form'
                                   })
    end

    it 'contains task title' do
      expect(rendered).to match(task.description.to_s)
    end

    it 'contains description input with appropriate class' do
      expect(rendered).to match("edit-task-description-#{task.id}")
    end

    it 'contains deadline input with appropriate class' do
      expect(rendered).to match("edit-task-deadline-#{task.id}")
    end

    it 'contains edit button with appropriate class and type' do
      expect(rendered).to have_tag('button', with: {
                                     class: 'text-warning', type: 'submit'
                                   })
    end
  end
end
