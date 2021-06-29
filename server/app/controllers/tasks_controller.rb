class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo
  before_action :set_todo_task, only: %i[show update destroy]

  include Paginable

  # GET /todos/:todo_id/tasks
  def index
    @tasks = Task.where(user: current_user, todo: @todo).page(current_page).per(per_page)
    options = get_links_serializer_options('todo_tasks_path', @tasks)
    render json: TaskSerializer.new(@tasks, options).serializable_hash.to_json
  end

  # GET /todos/:todo_id/tasks/:id
  def show
    if @task.user != current_user
      task_not_found
      return
    end
    render json: TaskSerializer.new(@task).serializable_hash.to_json, status: :ok
  end

  # POST /todos/:todo_id/tasks
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    @task.todo = @todo
    if @task.save
      render json: TaskSerializer.new(@task).serializable_hash.to_json, status: :created
      return
    end
    render json: { error: @task.errors }, status: :unprocessable_entity
  end

  # PUT /todos/:todo_id/tasks/:id
  def update
    if @task.user != current_user
      task_not_found 
      return
    end
    if @task.update(task_params)
      head :no_content
      return
    end
    render json: @task.errors, status: :unprocessable_entity
  end

  # DELETE /todos/:todo_id/tasks/:id
  def destroy
    if @task.user != current_user
      task_not_found 
      return
    end
    if @task.destroy
      head :no_content
      return
    end
    render json: @task.errors, status: :unprocessable_entity
  end

  private

  def task_not_found
    render json: { success: false, errors: ['You don\'t have this task'] }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:content, :status, :expired_at)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  def set_todo_task
    @task = @todo.tasks.find_by!(id: params[:id]) if @todo
  end
end
