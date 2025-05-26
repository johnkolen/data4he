require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  classSetup object: :create_student_user,
             user: :admin_user

  views_models_edit
end
