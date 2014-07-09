class Api::V1::TasksController < ApplicationController
  before_action :authenticate
  
  # GET /api/v1/tasks.json
  def index; end

  # POST /api/v1/tasks.json
  def create; end

  # GET /api/v1/tasks/:id.json
  def show; end

  # PATCH /api/v1/tasks/:id.json
  def update; end
  
  # DELETE /api/v1/tasks/:id.json
  def destroy; end
end
