FactoryBot.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    date_of_birth { Date.today - 30.years - rand(365).days }
    ssn { "123-45-6789" }
    age { 30 }
    factory :student_person do
      date_of_birth { Date.today - 19.years - rand(365).days }
      ssn { "321-45-6789" }
      age { 19 }
    end
    factory :student_person_1 do
      date_of_birth { Date.today - 20.years - rand(365).days }
      ssn { "321-45-6789" }
      age { 20 }
    end
  end
end
