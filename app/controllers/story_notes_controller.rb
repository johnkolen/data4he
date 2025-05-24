class StoryNotesController < ApplicationController
  before_action :set_story_note, only: %i[ show edit update destroy ]

  # GET /story_notes or /story_notes.json
  def index
    @objects = @story_notes = StoryNote.all
  end

  # GET /story_notes/1 or /story_notes/1.json
  def show
  end

  # GET /story_notes/new
  def new
    @object = @story_note = StoryNote.new
  end

  # GET /story_notes/1/edit
  def edit
  end

  # POST /story_notes or /story_notes.json
  def create
    @object = @story_note = StoryNote.new(story_note_params)

    respond_to do |format|
      if @object = @story_note.save
        format.html { redirect_to @object = @story_note, notice: "Story note was successfully created." }
        format.json { render :show, status: :created, location: @object = @story_note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @object = @story_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_notes/1 or /story_notes/1.json
  def update
    respond_to do |format|
      if @object = @story_note.update(story_note_params)
        format.html { redirect_to @object = @story_note, notice: "Story note was successfully updated." }
        format.json { render :show, status: :ok, location: @object = @story_note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @object = @story_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_notes/1 or /story_notes/1.json
  def destroy
    @object = @story_note.destroy!

    respond_to do |format|
      format.html { redirect_to story_notes_path, status: :see_other, notice: "Story note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def self.story_note_params
    [ :note, :author, :story_task_id ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_note
      @object = @story_note = StoryNote.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def story_note_params
      params.expect(story_note: self.class.story_note_params)
    end
end
