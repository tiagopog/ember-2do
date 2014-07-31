class Api::V1::TasksController < ApplicationController
  before_action :authenticate!
  before_action :find_project, only: [:index, :create]
  before_action :find_task, except: [:index, :create]

  respond_to :json

  # GET /api/v1/:project_id/tasks
  # GET /api/v1/:project_id/tasks/filter/:done
  def index
    tasks = Task.filter(@project.tasks, fix_done(params[:done]))
    respond_with tasks, 
      status: tasks.blank? ? 404 : 200,
      callback: params['callback']
  end

  # POST /api/v1/:project_id/tasks
  def create
    task = Task.new(task_params)
    task.project = @project

    if task.save
      respond_with task, location: api_v1_project_tasks_url(task),
                   status: 200
    else
      render json: { errors: task.errors.full_messages },
             status: 422
    end
  end

  # GET /api/v1/:project_id/tasks/:id
  def show
    respond_with @task, status: 200
  end

  # PATCH /api/v1/:project_id/tasks/:id
  def update
    update_task(task_params)
  end

  # PATCH /api/v1/:project_id/tasks/:id/done
  def done
    update_task(done: !@task.done)
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    respond_with @task, status: 204 if @task.delete
  end

  private

  def fix_done(done)
    done == 'done' unless done.nil?
  end

  # Find within the eager loaded projects.
  def find_project
    @project = @current_user.projects.select do |e| 
      e.slug == params[:project_id]
    end.first
  end

  def find_task
    @task = @current_user.tasks.find(params[:id])
  end

  def update_task(params)
    if @task && @task.update(params)
      respond_with @task, status: 204
    else
      render json: { errors: @task.errors.full_messages },
             status: 422
    end
  end

  def task_params
    params.require(:task).permit(:name, :description, :done, :priority)
  end
end
