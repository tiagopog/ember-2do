class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate
  
  # GET /api/v1/projects.json
  def index; end

  # POST /api/v1/projects.json
  def create; end

  # GET /api/v1/projects/:id.json
  def show; end

  # PUT /api/v1/projects/:id.json
  def update; end
  
  # DELETE /api/v1/projects/:id.json
  def destroy; end
end
