require 'rails_helper'

RSpec.describe "students/index", type: :view do
  classSetup objects: [
               :create_student_sample,
               :create_student_sample
             ],
             user: :admin_user

  views_models_index
end
