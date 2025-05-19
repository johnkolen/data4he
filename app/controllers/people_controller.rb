class PeopleController < ApplicationController
  before_action :authenticate_user!

  before_action :set_person, only: %i[ show edit update destroy ]
  before_action :set_klass

  # GET /people or /people.json
  def index
    @objects = @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show
  end

  # GET /people/new
  def new
    @object = @person = Person.new
    @person.phone_numbers.build # used by Object View for template
  end

  # GET /people/1/edit
  def edit
    @person.phone_numbers.build # used by Object View for template
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_path, status: :see_other, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /people/render
  def visual
    # used for CSS debuging
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @object = @person = Person.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.
        expect! person: [
                 :first_name,
                 :last_name,
                 :date_of_birth,
                 :ssn,
                 :age,
                 phone_numbers_attributes: [ [ # many-to-many
                   :id,
                   :number,
                   :primary,
                   :active,
                   :_destroy # if true, destroy the object
                 ] ]
               ]
    end
end
