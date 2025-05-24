require 'rails_helper'

RSpec.describe "story_notes/edit", type: :view do
  let(:story_note) {
    StoryNote.create!(
      note: "MyString",
      author: "MyString",
      story_task: nil
    )
  }

  before(:each) do
    assign(:story_note, story_note)
  end

  it "renders the edit story_note form" do
    render

    assert_select "form[action=?][method=?]", story_note_path(story_note), "post" do

      assert_select "input[name=?]", "story_note[note]"

      assert_select "input[name=?]", "story_note[author]"

      assert_select "input[name=?]", "story_note[story_task_id]"
    end
  end
end
