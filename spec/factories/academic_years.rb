FactoryBot.define do
  factory :academic_year do
    year { "2020-2021" }
    5.times do |i|
      factory "ay_202#{i}".to_sym do
        year { "202#{i}-202#{i + 1}" }
      end
    end
  end
end
