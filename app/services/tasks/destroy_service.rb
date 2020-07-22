module Tasks
  class DestroyService < ApplicationService
    attr_accessor :project, :task

    def initialize(project, task)
      @project = project
      @task = task
    end

    def call
      Task.transaction do
        reassign_task_positions if task.destroy
        return true
      rescue ActiveRecord::RecordInvalid
        return false
      end
    end

    private

    def reassign_task_positions
      project.tasks.order(position: :asc).each_with_index do |task_to_reassign, index|
        next if task_to_reassign.position == index + 1

        task_to_reassign.position = index + 1
        task_to_reassign.save(validate: false)
      end
    end
  end
end
