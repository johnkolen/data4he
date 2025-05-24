FactoryBot.define do
  factory :story_note do
    note { "MyString" }
    author { "MyString" }
    story_task { nil }
  end
end
