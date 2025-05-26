require 'rails_helper'

RSpec.describe "story_tasks/edit", type: :view do
  classSetup object: :create_story_task,
             user: :admin_user

  it "renders the edit story_task form" do
    skip "RETURN LATER"
    @turbo = nil
    render
    story_task = object
    prettyprint response

    assert_select "input[name=\"story_task[title]\"]"

    assert_select "form[action=?][method=?]", story_task_path(story_task), "post" do
      assert_select "input[name=\"story_task[title]\"]"
      assert_select "input[name=?]", "story_task[title]"

      assert_select "textarea[name=?]", "story_task[description]"

      assert_select "input[name=?]", "story_task[priority]"

      assert_select "select[name=?]", "story_task[status_id]"
    end
  end
end
