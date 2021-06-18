class TodosController < ApplicationController
	before_action :authenticate_user!
	before_action :set_todo, only: %i[show update destroy]

  # after_action :set_pagination_header(:todos), only: %i[index]

  # GET /todos
  def index
    @todos = Todo.where(user: current_user).page params[:page]
    render json: { todos: @todos }, status: :ok
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    if @todo.save
      render json: { todo: @todo }, status: :created
      return
    end
    render json: { errors: @todo.errors }, status: :unprocessable_entity
  end

  # GET /todos/:id
  def show
    if @todo.user != current_user
      render json: { success: false, errors: ['You don\'t have this todo'] }, status: :not_found
      return
    end
    render json: { todo: @todo }, status: :ok
  end

  # PUT /todos/:id
  def update
    if @todo.user != current_user
      render json: { success: false, errors: ['You don\'t have this todo'] }, status: :not_found
      return
    end
    if @todo.update(todo_params)
      head :no_content
      return
    end
    render json: @todo.errors, status: :unprocessable_entity
  end

  # DELETE /todos/:id
  def destroy
     if @todo.user != current_user
        render json: { success: false, errors: ['You don\'t have this todo'] }, status: :not_found
        return
      end
      if @todo.destroy
        head :no_content
        return
      end
      render json: @todo.errors, status: :unprocessable_entity
  end

  private

  def todo_params
    # # whitelist params
    params.require(:todo).permit(:title, :short_description)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end
end
