class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate!
  respond_to :json

  # GET /api/v1/projects
  def index
    respond_with @current_user.projects, status: 200
  end

  # POST /api/v1/projects
  def create
    project = Project.new(project_params)
    project.author = @current_user
    
    if project.save
      respond_with project, location: api_v1_project_url(project), status: 200
    else
      render json: { errors: project.errors.full_messages }, status: 422
    end
  end

  # GET /api/v1/projects/:id
  def show
    project = Project.load_with_tasks(@current_user.id, params[:id])
    respond_with project, status: project.blank? ? 404 : 200
  end

  # PATCH /api/v1/projects/:id
  def update
    project = @current_user.projects.find_by(slug: params[:id])
    
    if project.update(project_params)
      respond_with project, status: 204
    else
      render json: { errors: project.errors.full_messages }, status: 422
    end
  end
  
  # DELETE /api/v1/projects/:id
  def destroy
    project = @current_user.projects.find_by(slug: params[:id])
    respond_with project, status: 204 if project.delete
  end

  private

  def project_params
    params.require(:project).permit(:id, :name, :slug, :author)
  end
end
