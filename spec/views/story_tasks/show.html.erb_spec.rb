require 'rails_helper'

RSpec.describe "story_tasks/show", type: :view do
  before(:each) do
    assign(:story_task, StoryTask.create!(
      title: "Title",
      description: "Description",
      priority: 2,
      status_id: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
