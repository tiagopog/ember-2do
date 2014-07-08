class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate
  
  # GET /api/v1/projects
  def index
    render json: 'foobar'
  end

  # POST /api/v1/projects
  def create; end

  # GET /api/v1/projects/:id
  def show; end

  # PUT /api/v1/projects/:id
  def update; end
  
  # DELETE /api/v1/projects/:id
  def destroy; end
end
