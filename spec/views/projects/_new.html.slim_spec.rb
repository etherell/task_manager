RSpec.describe "projects/_new" do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
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
end