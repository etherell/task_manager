require 'rails_helper'

RSpec.describe 'projects/index' do
  let(:user) { create(:user) }
  let(:quantity) { 5 }
  let!(:random_projects) { create_list(:project, quantity) }
  let!(:user_projects) { create_list(:project, quantity, user: user) }

  before do
    sign_in user
    assign(:projects, user.projects)
    render
  end

  describe 'crete project form' do
    it 'contains input to create new project' do
      expect(rendered).to have_tag('input', with: { class: 'new-project-form' })
    end

    it 'contains add new project button' do
      expect(rendered).to have_tag('input', with: { value: 'Add new project' })
    end
  end

  describe 'user projects' do
    it 'contains 5 projects with edit buttons' do
      expect(rendered).to have_tag('a', count: quantity, with: { class: 'edit-btn' })
    end

    it 'contains 5 projects with delete buttons' do
      expect(rendered).to have_tag('a', count: quantity, with: { class: 'delete-btn' })
    end

    it 'returns projects with appropriate titles' do
      user_projects.each do |project|
        expect(rendered).to match(project.title.to_s)
      end
    end

    it "doesn't returns other user projects" do
      random_projects.each do |project|
        expect(rendered).not_to match(project.title.to_s)
      end
    end
  end
end
