require 'rails_helper'

RSpec.describe "students/show", type: :view do
  classSetup object: :create_student,
             user: :admin_user

  views_models_show
end
