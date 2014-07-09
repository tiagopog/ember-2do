class Api::V1::TasksController < ApplicationController
  before_action :authenticate
  
  # GET /api/v1/:project_id/tasks
  def index
    tasks = 
      Task.load_with_project(params[:project_id], @current_user.id, params[:done])
    
    if tasks.blank?
      json({ message: http_error_msg[404] }, 404)
    else
      json({ project: tasks.first.project, tasks: tasks }, 200)
    end
  end

  # POST /api/v1/:project_id/tasks
  def create
    task = Task.new(task_params)
    task.project_id = params[:project_id]
    
    if task.save
      json({ task: task }, 200)
    else
      json({ message: http_error_msg[422],
             errors: task.errors.full_messages }, 422)
    end
  end

  # GET /api/v1/:project_id/tasks/:id
  def show
    json({ task: @current_user.tasks.find(params[:id]) }, 200)
  rescue
    json({ message: http_error_msg[404] }, 404)
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

    if task && task.delete
      json({ task: task }, 200)
    else
      json({ message: http_error_msg[422] }, 422)
    end
  rescue
    json({ message: http_error_msg[404] }, 404)
  end

  private

  def update_task(params)
    if @task && @task.update(params)
      json({ task: @task }, 200)
    else
      json({ message: http_error_msg[422],
             errors: @task.errors.full_messages }, 422)
    end
  end

  def task_params
    params.require(:task).permit(:name, :description, :done, :priority)
  end
end
