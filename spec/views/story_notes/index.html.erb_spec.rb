require 'rails_helper'

RSpec.describe "story_notes/index", type: :view do
  before(:each) do
    assign(:story_notes, [
      StoryNote.create!(
        note: "Note",
        author: "Author",
        story_task: nil
      ),
      StoryNote.create!(
        note: "Note",
        author: "Author",
        story_task: nil
      )
    ])
  end

  it "renders a list of story_notes" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Note".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Author".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
