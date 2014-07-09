class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate

  # GET /api/v1/projects
  def index
    json({ user: @current_user, projects: @current_user.projects }, 200)
  end

  # POST /api/v1/projects
  def create
    project = Project.new(project_params)
    project.author = @current_user
    
    if project.save
      json({ project: project }, 200)
    else
      json({ message:  http_error_msg[422],
             errors: project.errors.full_messages }, 422)
    end
  end

  # GET /api/v1/projects/:id
  def show
    project = Project.load_with_tasks(@current_user.id, params[:id])
    
    if project.blank?
      json({ message: http_error_msg[404] }, 404)
    else
      json({ project: project, tasks: project.tasks }, 200)
    end
  end

  # PATCH /api/v1/projects/:id
  def update
    project =
      Project.find_by(user_id: @current_user.id, slug: params[:id])
    
    if project && project.update(project_params)
      json({ project: project }, 200)
    else
      json({ message: http_error_msg[422],
             errors: project.errors.full_messages }, 422)
    end
  end
  
  # DELETE /api/v1/projects/:id
  def destroy
    project =
      Project.find_by(user_id: @current_user.id, slug: params[:id])

    if project && project.delete
      json({ project: project }, 200)
    else
      json({ message: http_error_msg[422] }, 422)
    end
  end

  private

  def project_params
    params.require(:project).permit(:id, :name, :slug, :author)
  end
end
