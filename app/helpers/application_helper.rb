module ApplicationHelper
  def onboarding_step_class(step_number, current_step)
    if step_number < current_step
      "completed"
    elsif step_number == current_step
      "active"
    else
      "pending"
    end
  end

  def onboarding_step_label(step_number, current_step)
    if step_number < current_step
      "&#10003;".html_safe
    else
      step_number.to_s
    end
  end

  def progress_percentage(current_step, total_steps)
    ((current_step.to_f - 1) / total_steps * 100).round
  end

  def database_options
    [
      ["PostgreSQL", "postgresql"],
      ["MySQL", "mysql"],
      ["SQLite", "sqlite"]
    ]
  end

  def gem_options
    [
      ["Devise (authentication)", "devise"],
      ["RSpec (testing)", "rspec"],
      ["Sidekiq (background jobs)", "sidekiq"],
      ["Pundit (authorization)", "pundit"],
      ["Kaminari (pagination)", "kaminari"]
    ]
  end
end