class ProjectsController < ApplicationController
  before_action :authenticate
  load_and_authorize_resource :project, except: :create
  before_action :find_project!, only: %i[edit update destroy]
  before_action :flash_clear
  respond_to :js

  def index
    @projects = current_user.projects.includes(:tasks)
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      flash[:success] = 'Project was successfully created.'
    else
      flash[:error] = @project.errors.full_messages.join('. ')
      render status: 422
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project was successfully updated.'
    else
      flash[:error] = @project.errors.full_messages.join('. ')
      render status: 422
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = 'Project was successfully deleted.'
    else
      flash[:error] = 'Project wasn\'t deleted.'
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

  def authenticate
    redirect_to new_user_session_path unless current_user
    flash[:error] = 'Please, log in or sign up to continue'
  end
end
