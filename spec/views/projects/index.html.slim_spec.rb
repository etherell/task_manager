require 'rails_helper'

RSpec.describe "projects/index" do
  let(:user) { create(:user) }
  let(:number_of_projects) { 5 }
  let!(:random_projects) { create_list(:project, number_of_projects) }
  let!(:user_projects) { create_list(:project, number_of_projects, user: user) }

  before do
    sign_in user
    assign(:projects, user.projects)
    render
  end

  describe "crete project form" do
    it "contains input to create new project" do
      expect(rendered).to have_tag("input", with: { class: "new-project-form" })
    end

    it "contains add new project button" do
      expect(rendered).to have_tag("input", with: { value: "Add new project" })
    end
  end

  describe "user projects" do
    it "contains 5 projects with destroy and edit buttons" do
      expect(rendered).to have_tag("a", count: number_of_projects, with: { class: "edit-btn" })
      expect(rendered).to have_tag("a", count: number_of_projects, with: { class: "delete-btn" })
    end

    it "returns projects with appropriate titles" do
      user_projects.each do |project|
        expect(rendered).to match("#{project.title}")
      end
    end

    it "doesn't returns other user projects" do
      random_projects.each do |project|
        expect(rendered).to_not match("#{project.title}")
      end
    end
  end
end
