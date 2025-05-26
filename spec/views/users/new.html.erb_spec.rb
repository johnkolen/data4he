require 'rails_helper'

RSpec.describe "users/new", type: :view do
  include ControllerSetup
  classSetup object: :build_student_user,
             user: :admin_user

  views_models_new
end
