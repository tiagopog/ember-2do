class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate!
  before_action :find_project, only: [:show, :update, :destroy]

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
      respond_with project,
        location: api_v1_project_url(project),
        status: 200
    else
      render json: { errors: project.errors.full_messages }, status: 422
    end
  end

  # GET /api/v1/projects/:id
  def show
    respond_with @project, status: @project.blank? ? 404 : 200
  end

  # PATCH /api/v1/projects/:id
  def update
    if @project.update(project_params)
      respond_with @project, status: 204
    else
      render json: { errors: @project.errors.full_messages }, status: 422
    end
  end

  # DELETE /api/v1/projects/:id
  def destroy
    respond_with @project, status: 204 if @project.delete
  end

  private

  # Find within the eager loaded projects.
  def find_project
    @project = @current_user.projects.select do |e| 
      e.slug == params[:id]
    end.first
  end

  def project_params
    params.require(:project).permit(:id, :name, :slug, :author)
  end
end
