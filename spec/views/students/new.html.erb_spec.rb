require 'rails_helper'

RSpec.describe "students/new", type: :view do
  classSetup object: :build_student,
             user: :admin_user

  views_models_new
end
