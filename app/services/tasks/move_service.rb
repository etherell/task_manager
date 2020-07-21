module Tasks
  class MoveService < ApplicationService
    require 'json'

    attr_accessor :task,
                  :project,
                  :target_tasks_ids,
                  :source_tasks_ids

    def initialize(task, project, target_tasks_ids, source_tasks_ids = nil)
      @task = task
      @project = project
      @target_tasks_ids = JSON.parse(target_tasks_ids) if target_tasks_ids.is_a? String
      @source_tasks_ids = JSON.parse(source_tasks_ids) if source_tasks_ids.is_a? String
    end

    def call
      Task.transaction do
        update_tasks_position(target_tasks_ids)
        update_tasks_position(source_tasks_ids) if source_tasks_ids.present?
        return true, 'Message was successfully moved.'
      rescue ActiveRecord::RecordInvalid
        return false, 'Message wasn\'t moved.'
      end
    end

    private

    def update_tasks_position(tasks_ids)
      tasks_ids.each_with_index do |task_id, index|
        task_to_update = Task.find(task_id)
        task_to_update.project = project if task_to_update == task
        task_to_update.position = index + 1
        task_to_update.save(validate: false)
      end
    end
  end
end
