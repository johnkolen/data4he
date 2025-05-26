require 'rails_helper'

RSpec.describe StoryNote, type: :model do
  it "initializes" do
    sn = StoryNote.new
    expect(sn).to be_a StoryNote
  end
end
