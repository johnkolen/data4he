FactoryBot.define do
  factory :phone_number do
    number { "(832)123-4563" }
    active { true }
    primary { true }
    person
  end
end
