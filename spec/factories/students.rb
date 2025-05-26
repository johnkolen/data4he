FactoryBot.define do
  factory :student do
    inst_id { "123456" }
    person factory: :student_person
    catalog_year_id do
      ay = build(:academic_year);
      AcademicYear.find_or_create_by(year: ay.year).id
    end
    factory :student_1 do
      inst_id { "321456" }
      person factory: :student_person_1
      catalog_year factory: :ay_2022
    end
    factory :student_sample do
      inst_id { (10000 + rand(900000)).to_s }
      person factory: :person
    end
  end

end
