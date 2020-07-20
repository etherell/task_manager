module Tasks
  class CreateService < ApplicationService
    attr_accessor :task_params, :user, :project

    def initialize(task_params, user, project)
      @task_params = task_params
      @user = user
      @project = project
    end

    def call
      task = project.tasks.build(task_params)
      task.user = user
      task.position = calculate_position
      task
    end

    private

    def calculate_position
      project.last_task_position.to_i + 1
    end
  end
end
