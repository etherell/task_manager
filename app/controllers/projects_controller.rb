class ProjectsController < ApplicationController
  before_action :find_project!, only: %i[edit update destroy]
  before_action :flash_clear
  respond_to :js

  def index
    @projects = Project.all
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = 'Project was successfully created.'
    else
      flash[:error] = @project.errors.full_messages.join("\n")
      render status: 422
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project was successfully updated.'
    else
      flash[:error] = @project.errors.full_messages.join("\n")
      render status: 422
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = 'Project was successfully deleted.'
    else
      flash[:error] = @project.errors.full_messages.join("\n")
      render status: 422
    end
  end

  private

  def find_project!
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title)
  end

  def flash_clear
    flash.clear
  end
end
