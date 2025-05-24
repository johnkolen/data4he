require 'rails_helper'

RSpec.describe "story_notes/new", type: :view do
  before(:each) do
    assign(:story_note, StoryNote.new(
      note: "MyString",
      author: "MyString",
      story_task: nil
    ))
  end

  it "renders new story_note form" do
    render

    assert_select "form[action=?][method=?]", story_notes_path, "post" do

      assert_select "input[name=?]", "story_note[note]"

      assert_select "input[name=?]", "story_note[author]"

      assert_select "input[name=?]", "story_note[story_task_id]"
    end
  end
end
