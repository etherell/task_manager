require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to belong_to(:user) }

  let(:project) { build(:project) }

  shared_examples "an object with errors" do
    it "returns appropriate error message" do
      project.update(data)
      expect(project.errors.to_a).to include(error_message)
    end
  end

  shared_examples "an object without errors" do
    it "doesn't return errors" do
      project.update(data)
      expect(project.errors.to_a).to be_empty
    end
  end

  describe "user presence" do

    context "without user" do
      let(:data) { { user: nil } }
      let(:error_message) { "User must exist" }
      it_behaves_like "an object with errors" 
    end

    context "with user" do
      let(:data) { { user: build(:user) } }
      it_behaves_like "an object without errors"
    end
    
  end

  describe "title length" do

    context "short title" do
      let(:data) { { title: "a" } }
      let(:error_message) { "Title is too short (minimum is 3 characters)" }
      it_behaves_like "an object with errors"
    end
  
    context "long title" do
      let(:data) { { title: "#{"a" * 51}" } }
      let(:error_message) { "Title is too long (maximum is 50 characters)" }
      it_behaves_like "an object with errors"
    end

    context "valid title" do
      let(:data) { { title: "#{"a" * 25}" } }
      it_behaves_like "an object without errors"
    end

  end

end
