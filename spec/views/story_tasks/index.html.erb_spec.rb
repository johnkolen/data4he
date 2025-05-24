require 'rails_helper'

RSpec.describe "story_tasks/index", type: :view do
  classSetup objects: [
               :create_story_task,
               :create_story_task
             ],
             user: :admin_user

  it "renders a list of story_tasks" do
    render
    cell_selector = 'tr>td'
    st = objects.first
    assert_select cell_selector, text: Regexp.new(st.title.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(st.status_str.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(st.priority.to_s), count: 2
  end
end
