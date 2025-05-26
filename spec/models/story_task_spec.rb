require 'rails_helper'

RSpec.describe StoryTask, type: :model do
  it "initializes" do
    st = StoryTask.new
    expect(st).to be_a StoryTask
  end
end
