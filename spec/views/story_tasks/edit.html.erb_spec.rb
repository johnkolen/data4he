require 'rails_helper'

RSpec.describe "story_tasks/edit", type: :view do
  let(:story_task) {
    StoryTask.create!(
      title: "MyString",
      description: "MyString",
      priority: 1,
      status_id: 1
    )
  }

  before(:each) do
    assign(:story_task, story_task)
  end

  it "renders the edit story_task form" do
    render

    assert_select "form[action=?][method=?]", story_task_path(story_task), "post" do

      assert_select "input[name=?]", "story_task[title]"

      assert_select "input[name=?]", "story_task[description]"

      assert_select "input[name=?]", "story_task[priority]"

      assert_select "input[name=?]", "story_task[status_id]"
    end
  end
end
