require 'rails_helper'

RSpec.describe "story_tasks/show", type: :view do
  include ControllerSetup
  classSetup object: :create_story_task,
             user: :admin_user

  it "renders attributes in <p>" do
    render
    st = object
    expect(rendered).to match(/#{st.title}/)
    expect(rendered).to match(/#{st.description}/)
    expect(rendered).to match(/#{st.priority}/)
    expect(rendered).to match(/#{st.status_str}/)
  end
end
