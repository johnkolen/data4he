require 'rails_helper'

RSpec.describe "users/index", type: :view do
  include ControllerSetup
  classSetup objects: [
               :create_student_user,
               :create_student_user_1
             ],
             user: :admin_user

  views_models_index
end
