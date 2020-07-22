RSpec.describe 'tasks/_new' do
  include_context 'with logged in user with project and task'

  before do
    render partial: 'tasks/new.html.slim', locals: { project: project }
  end

  describe 'new task form' do
    it 'contains form with appropriate class and type' do
      expect(rendered).to have_tag('div', with: {
                                     class: 'new-task-form'
                                   })
    end

    it 'contains description input with appropriate class' do
      expect(rendered).to match("add-task-description-#{project.id}")
    end

    it 'contains deadline input with appropriate class' do
      expect(rendered).to match("add-task-deadline-#{project.id}")
    end

    it 'contains button with appropriate class and type' do
      expect(rendered).to match("add-task-btn-#{project.id}")
    end
  end
end
