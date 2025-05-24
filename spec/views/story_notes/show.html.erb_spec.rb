require 'rails_helper'

RSpec.describe "story_notes/show", type: :view do
  before(:each) do
    assign(:story_note, StoryNote.create!(
      note: "Note",
      author: "Author",
      story_task: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Note/)
    expect(rendered).to match(/Author/)
    expect(rendered).to match(//)
  end
end
