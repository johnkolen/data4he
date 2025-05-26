require 'rails_helper'

RSpec.describe "users/edit_profile", type: :view do
  include ControllerSetup
  classSetup object: :create_student_user,
             user: :admin_user

  it "renders attributes with admin" do
    render
    assert_select "form[action=?][method=?]", user_path(object), "post" do
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[person][first_name]"
      assert_select "input[name=?]", "user[person][ssn]", 1
    end
  end

  it "renders attributes in <p>" do
    skip
    hold = Access.user
    Access.user = object
    render
    Access.user = hold
    node = Nokogiri::HTML(response)
    puts node.to_xhtml(indent: 2)

    assert_select "form[action=?][method=?]", user_path(object), "post" do
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[person][first_name]"
      assert_select "input[name=?]", "user[person][ssn]", 0
    end
  end
end
