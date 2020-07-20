class TasksController < ApplicationController
  before_action :find_project!
  before_action :find_task!, only: %i[edit update destroy done]
  before_action :flash_clear
  respond_to :js

  def new; end

  def create
    @task = Tasks::CreateService.call(task_params, current_user, @project)
    if @task.save
      flash[:success] = 'Task was successfully created.'
    else
      flash[:error] = @task.errors.full_messages.join('. ')
      render status: 422
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task was successfully updated.'
    else
      flash[:error] = @task.errors.full_messages.join('. ')
      render status: 422
    end
  end

  def edit; end

  def destroy
    if @task.destroy
      flash[:success] = 'Task was successfully deleted.'
    else
      flash[:error] = 'Task wasn\'t deleted'
      render status: 422
    end
  end

  def done
    @task.is_done? ? @task.not_done! : @task.done!
    if @task.errors.empty?
      flash[:success] = 'Task status was changed.'
    else
      flash[:error] = 'Task status wasn\'t changed'
      render status: 422
    end
  end

  private

  def find_project!
    @project = Project.find(params[:project_id])
  end

  def find_task!
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :deadline)
  end

  def flash_clear
    flash.clear
  end
end
