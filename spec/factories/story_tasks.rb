FactoryBot.define do
  factory :story_task do
    title { "A Title" }
    description { "A Description" }
    priority { 10 }
    status_id { StoryTask::StatusActive }
  end
end
