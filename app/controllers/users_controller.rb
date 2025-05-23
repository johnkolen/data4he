class UsersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user,
                only: %i[show edit update destroy switch profile edit_profile update_profile]
  before_action :set_klass

  def switch
    sign_in(:user, @user)
    set_access_user
    redirect_back(fallback_location: root_path)
  end

  # GET /users/1/profile
  def profile
  end

  # GET /users/1/edit_profile
  def edit_profie
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update_profile
    respond_to do |format|
      if @user.update(profile_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: profile_user_path(@user) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users or /users.json
  def index
    @objects = @users = User.all.select{|s| Access.allow? s, :view}
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @object = @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @object = @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def self.user_params
    [
      :email,
      :role_id,
      :password,
      :password_confirmation
    ]
  end

  def self.user_profile_params
    [
      :email,
      :role_id,
      :password,
      :password_confirmation,
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
      ]
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @object = @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.
        expect! user: self.class.user_params
    end

    def profile_params
      params.
        expect! user: self.class.user_profile_params
    end
end
