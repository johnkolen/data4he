FactoryBot.define do
  factory :story_task do
    title { "A Title" }
    description { "A Description" }
    priority { 10 }
    status_id { StoryTask::StatusActive }
    factory :story_task_sample do
      title { "Task #{rand(10000)}" }
    end
  end
end
