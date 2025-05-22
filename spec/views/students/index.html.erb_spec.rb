require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "students/index", type: :view do
  include ControllerSetup
  classSetup object: [
               :create_student,
               :create_student_1
             ],
             user: :admin_user

  it "renders a list of students" do
    render

    cell_selector = 'div>p'
    objects.each do |obj|
      expect(rendered).to match(/#{obj.inst_id}/)
    end
  end
end
