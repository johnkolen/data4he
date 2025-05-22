require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "users/edit", type: :view do
  include ControllerSetup
  before(:all) do
    @u = create(:admin_user)
  end
  before(:each) do
    controllerSetup @u
    Access.user = @u
  end
  let(:user) { @u }
  it "renders attributes in <p>" do
    render
    assert_select "form[action=?][method=?]", user_path(user), "post" do
    end
  end
end
