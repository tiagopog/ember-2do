class Api::V1::TasksController < ApplicationController
  before_action :authenticate!
  respond_to :json
  
  # GET /api/v1/:project_id/tasks
  def index
    tasks = 
      Task.load_with_project(params[:project_id], @current_user.id, params[:done])
    respond_with tasks, status: tasks.blank? ? 404 : 200
  end

  # POST /api/v1/:project_id/tasks
  def create
    task = Task.new(task_params)
    task.project_id = params[:project_id]
    
    if task.save
      respond_with task, location: api_v1_project_tasks_url(task), status: 200
    else
      render json: { errors: task.errors.full_messages }, status: 422
    end
  end

  # GET /api/v1/:project_id/tasks/:id
  def show
    task = @current_user.tasks.find(params[:id])
    respond_with task, status: 200
  rescue
    respond_with task, status: 404
  end

  # PATCH /api/v1/:project_id/tasks/:id
  def update
    @task = @current_user.tasks.find(params[:id])
    update_task(task_params)
  end

  # PATCH /api/v1/:project_id/tasks/:id/done
  def done
    @task = @current_user.tasks.find(params[:id])
    update_task(done: !@task.done)
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    task = @current_user.tasks.find(params[:id])
    respond_with task, status: 204 if task.delete
  end

  private

  def update_task(params)
    if @task && @task.update(params)
      respond_with @task, status: 204
    else
      render json: { errors: @task.errors.full_messages }, status: 422
    end
  end

  def task_params
    params.require(:task).permit(:name, :description, :done, :priority)
  end
end
