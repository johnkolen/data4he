FactoryBot.define do
  factory :person do
    first_name { "Alex" }
    last_name { "Smith" }
    date_of_birth { Date.today - 30.years - 1.day }
    ssn { "123-45-6789" }
    age { 30 }
    factory :person_sample do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.first_name }
      transient do
        yold { 18 + rand(20) }
      end
      date_of_birth { Date.today - yold.years - rand(365).days}
      ssn { "%03d-%02d-%04d" % [rand(1000), rand(100), rand(10000)] }
      age { yold }
      factory :student_person do
        date_of_birth { Date.today - 19.years - rand(365).days }
        age { 19 }
      end
      factory :student_person_1 do
        date_of_birth { Date.today - 20.years - rand(365).days }
        age { 20 }
      end
    end
  end
  trait :with_person_sample do
    after(:create) do |obj|
      create(:person_sample, person_id: obj.id)
    end
  end
end
