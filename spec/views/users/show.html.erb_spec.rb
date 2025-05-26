require 'rails_helper'

RSpec.describe "users/show", type: :view do
  include ControllerSetup
  classSetup object: :create_student_user,
             user: :admin_user

  views_models_show
end
