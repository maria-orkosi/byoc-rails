require_relative "../spec_helper"

RSpec.describe ApplicationHelper do
  describe "#onboarding_step_class" do
    it "returns 'completed' for steps before current" do
      expect(helper.onboarding_step_class(1, 3)).to eq("completed")
      expect(helper.onboarding_step_class(2, 3)).to eq("completed")
    end

    it "returns 'active' for the current step" do
      expect(helper.onboarding_step_class(3, 3)).to eq("active")
    end

    it "returns 'pending' for steps after current" do
      expect(helper.onboarding_step_class(4, 3)).to eq("pending")
    end
  end

  describe "#onboarding_step_label" do
    it "returns checkmark for completed steps" do
      result = helper.onboarding_step_label(1, 3)
      expect(result).to include("&#10003;")
    end

    it "returns step number for current or pending steps" do
      expect(helper.onboarding_step_label(3, 3)).to eq("3")
      expect(helper.onboarding_step_label(4, 3)).to eq("4")
    end
  end

  describe "#progress_percentage" do
    it "calculates progress correctly" do
      expect(helper.progress_percentage(1, 4)).to eq(0)
      expect(helper.progress_percentage(2, 4)).to eq(25)
      expect(helper.progress_percentage(4, 4)).to eq(75)
    end
  end

  describe "#database_options" do
    it "returns array of database choices" do
      options = helper.database_options
      expect(options.length).to eq(3)
      expect(options.map(&:last)).to include("postgresql", "mysql", "sqlite")
    end
  end

  describe "#gem_options" do
    it "returns array of gem choices" do
      options = helper.gem_options
      expect(options.length).to eq(5)
      expect(options.map(&:last)).to include("devise", "rspec", "sidekiq", "pundit", "kaminari")
    end
  end
end