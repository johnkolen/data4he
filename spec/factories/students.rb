FactoryBot.define do
  factory :student do
    inst_id { "123456" }
    person factory: :student_person
    catalog_year factory: :academic_year
    factory :student_1 do
      inst_id { "321456" }
      person factory: :student_person_1
      catalog_year factory: :ay_2022
    end
  end
end
