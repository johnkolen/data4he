require 'rails_helper'

RSpec.describe "story_tasks/new", type: :view do
  before(:each) do
    assign(:story_task, StoryTask.new(
      title: "MyString",
      description: "MyString",
      priority: 1,
      status_id: 1
    ))
  end

  it "renders new story_task form" do
    render

    assert_select "form[action=?][method=?]", story_tasks_path, "post" do

      assert_select "input[name=?]", "story_task[title]"

      assert_select "input[name=?]", "story_task[description]"

      assert_select "input[name=?]", "story_task[priority]"

      assert_select "input[name=?]", "story_task[status_id]"
    end
  end
end
