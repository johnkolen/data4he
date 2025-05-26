FactoryBot.define do
  factory :phone_number do
    number { "(832)123-4563" }
    active { true }
    primary { true }
    person
  end
  trait :with_phone_number do
    after(:create) do |person|
      create(:phone_number, person_id: person.id)
    end
  end
end
