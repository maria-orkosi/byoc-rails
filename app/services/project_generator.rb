class ProjectGenerator
  attr_reader :user, :data

  def initialize(user, data)
    @user = user
    @data = data
  end

  def call
    project = user.projects.create!(
      name: data[:project_name],
      database_choice: data[:database_choice],
      gems: Array(data[:gems]).reject(&:blank?),
      commit_message: data[:commit_message],
      status: "scaffolded"
    )

    Rails.logger.info("Project #{project.name} scaffolded for user #{user.id}")

    project
  end
end