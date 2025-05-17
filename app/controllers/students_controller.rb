class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  before_action :set_klass

  # GET /students or /students.json
  def index
    @objects = @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @object = @student = Student.new
    @student.build_person
    @student.person.phone_numbers.build
  end

  # GET /students/1/edit
  def edit
    @student.person.phone_numbers.build
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_path, status: :see_other, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @object = @student = Student.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.
        expect(student: [
                 :inst_id,
                 :catalog_year_id,
                 # has_one relationship requires one bracket
                 person_attributes: [
                     :first_name,
                     :last_name,
                     :date_of_birth,
                     :ssn,
                     :age,
                     # has_many relationship requires two brackets
                     phone_numbers_attributes: [
                       [
                         :id,
                         :number,
                         :primary,
                         :active,
                         :_destroy # if true, destroy the object
                       ] ]
                   ] # end of person_attributes
                 ])
    end
end
