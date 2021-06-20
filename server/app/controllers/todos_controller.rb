class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[show update destroy]

 # after_action :set_pagination_header(:todos), only: %i[index]

 #include Hyperender::Action

  include Paginable

 # GET /todos
  def index
    @todos = current_user.todos.page(current_page).per(per_page)
    options = get_links_serializer_options('todos_path', @todos)
    # options[:include] = [:user]
    render json: TodoSerializer.new(@todos, options).serializable_hash.to_json
  end

 # POST /todos
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    if @todo.save
      render json: TodoSerializer.new(@todo).serializable_hash.to_json, status: :created
      return
    end
    render json: { errors: @todo.errors }, status: :unprocessable_entity
  end

 # GET /todos/:id
  def show
    if @todo.user != current_user
      not_found_todo
      return
    end
    render json: TodoSerializer.new(@todo, included_chain).serializable_hash.to_json, status: :ok
  end

 # PUT /todos/:id
  def update
    if @todo.user != current_user
      not_found_todo
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
      not_found_todo
      return
    end
    if @todo.destroy
      head :no_content
      return
    end
    render json: @todo.errors, status: :unprocessable_entity
  end

  private

  def included_chain
    Hash.new(include: [:tasks])
  end

  def not_found_todo
    render json: { success: false, errors: ['You don\'t have this todo'] }, status: :not_found
  end

  def todo_params
    # # whitelist params
    params.require(:todo).permit(:title, :short_description)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end
end
