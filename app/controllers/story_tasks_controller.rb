class StoryTasksController < ApplicationController
  before_action :set_story_task,
                only: %i[ show edit update destroy to_to_do to_active to_blocked to_finished]

  before_action :set_klass
  before_action :set_turbo, only: %i[ show edit update ]

  # GET /story_tasks or /story_tasks.json
  def index
    tasks = StoryTask.all. sort do |a, b|
      [ a.status_id, -a.priority ] <=> [ b.status_id, -b.priority ]
    end
    @objects = @story_tasks = tasks
  end

  # GET /story_tasks or /story_tasks.json
  def kanban
    @columns = {
      StoryTask::StatusToDo => StoryTask.todo.all,
      StoryTask::StatusActive => StoryTask.active.all,
      StoryTask::StatusBlocked => StoryTask.blocked.all,
      StoryTask::StatusFinished => StoryTask.finished.all
    }
  end

  # GET /story_tasks/1 or /story_tasks/1.json
  def show
  end

  # GET /story_tasks/new
  def new
    @object = @story_task = StoryTask.new
    @story_task.add_builds!
  end

  # GET /story_tasks/1/edit
  def edit
    @story_task.add_builds!
  end

  # POST /story_tasks or /story_tasks.json
  def create
    @object = @story_task = StoryTask.new(story_task_params)

    respond_to do |format|
      if @story_task.save
        format.html { redirect_to @story_task, notice: "Story task was successfully created." }
        format.json { render :show, status: :created, location: @story_task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_tasks/1 or /story_tasks/1.json
  def update
    respond_to do |format|
      if @story_task.update(story_task_params)
        format.html {
          redirect_to story_task_path(@story_task, params: @tfp),
                      notice: "Story task was successfully updated." }
        format.json { render :show, status: :ok, location: @story_task }
      else
        format.html {
          render :edit,
                 status: :unprocessable_entity
        }
        format.json { render json: @story_task.errors, status: :unprocessable_entity }
      end
    end
  end

  def to_to_do
    change_status StoryTask::StatusToDo
  end

  def to_active
    change_status StoryTask::StatusActive
  end

  def to_blocked
    change_status StoryTask::StatusBlocked
  end

  def to_finished
    change_status StoryTask::StatusFinished
  end

  def change_status(status_id)
    respond_to do |format|
      if @story_task.update(status_id: status_id)
        format.html { redirect_back fallback_location: :kanban, notice: "Story task was successfully updated." }
        format.json { render :kanban, status: :ok, location: @story_task }
      else
        # TODO this should be delt with
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_tasks/1 or /story_tasks/1.json
  def destroy
    @story_task.destroy!

    respond_to do |format|
      format.html { redirect_to story_tasks_path, status: :see_other, notice: "Story task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def self.story_task_params
    [ :title,
      :description,
      :priority,
      :status_id,
      story_notes_attributes: [
        [
          :id,
          :note,
          :author,
          :_destroy
        ]
      ]
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_task
      @object = @story_task = StoryTask.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def story_task_params
      params.expect(story_task: self.class.story_task_params)
    end
end
