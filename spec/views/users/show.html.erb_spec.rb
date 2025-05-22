require 'rails_helper'
require_relative "../controller_setup"

RSpec.describe "users/show", type: :view do
  include ControllerSetup
  before(:all) do
    @u = create(:admin_user)
    assign(:user, @u)
    assign(:object, @u)
    assign(:klass, @u.class)
    Access.user = @u
  end
  before(:each) do
    controllerSetup @u
    Access.user = @u
  end
  after(:all) do
    @u.destroy
  end

  it "renders attributes in <p>" do
    render #locals: {user: @user}
  end
end
