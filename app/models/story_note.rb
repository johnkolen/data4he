class StoryNote < ApplicationRecord
  belongs_to :story_task

  include MetaAttributes
end
