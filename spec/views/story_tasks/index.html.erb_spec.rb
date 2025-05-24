require 'rails_helper'

RSpec.describe "story_tasks/index", type: :view do
  before(:each) do
    assign(:story_tasks, [
      StoryTask.create!(
        title: "Title",
        description: "Description",
        priority: 2,
        status_id: 3
      ),
      StoryTask.create!(
        title: "Title",
        description: "Description",
        priority: 2,
        status_id: 3
      )
    ])
  end

  it "renders a list of story_tasks" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
