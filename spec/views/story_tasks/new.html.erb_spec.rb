require 'rails_helper'

RSpec.describe "story_tasks/new", type: :view do
  classSetup object: :build_story_task,
             user: :admin_user

  it "renders new story_task form" do
    render

    assert_select "form[action=?][method=?]", story_tasks_path, "post" do
      assert_select "input[name=?]", "story_task[title]"
      assert_select "textarea[name=?]", "story_task[description]"
      assert_select "input[name=?]", "story_task[priority]"
      assert_select "select[name=?]", "story_task[status_id]"
    end
  end
end
