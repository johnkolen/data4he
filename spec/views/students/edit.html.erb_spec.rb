require 'rails_helper'

RSpec.describe "students/edit", type: :view do
  classSetup object: :create_student,
             user: :admin_user

  views_models_edit
end
