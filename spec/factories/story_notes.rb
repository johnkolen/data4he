FactoryBot.define do
  factory :story_note do
    note { "MyString" }
    author { "MyString" }
    story_task { nil }
  end
  trait :with_story_note do
    after(:create) do |task|
      create(:story_note, story_task_id: task.id)
    end
  end
end
