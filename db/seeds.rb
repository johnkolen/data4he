# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

5.times do |i|
  AcademicYear.find_or_create_by!(year: "#{2020 + i}-#{2021 + i}")
end

[%w{admin@d4he.com admin! 1},
 %w{support@d4he.com support 2},
 %w{recruiter@demo.edu recruiter 101},
 %w{registrar@demo.edu registrar 102},
 %w{student001@demo.edu student 103},
 %w{student002@demo.edu student 103},
 %w{student003@demo.edu student 103},
 %w{faculty001@demo.edu student 104},
 %w{faculty002@demo.edu student 104},
 %w{admin001@demo.edu admin! 105},
 %w{admin002@demo.edu admin! 105}
].each do |email, password, role_id|
  User.find_or_create_by!(email: email) do |u|
    u.password = password
    u.password_confirmation = password
    u.role_id = role_id
  end
end

User.where(person_id: nil).each do |u|
  next if u.role_id < 100
  p = u.build_person
  p.first_name = rand(2) == 0 ?
                   Faker::Name.first_name_men :
                   Faker::Name.first_name_women
  p.last_name = Faker::Name.last_name
  p.ssn = "%03d-%02d-%04d" % [rand(1000), rand(100), rand(10000)]
  p.age = 18 + rand(30)
  p.date_of_birth = Date.today - 365 * p.age - rand(364)
  pn = p.phone_numbers.build
  pn.number = "(%3d)%03d-%04d" % [100 + rand(799), rand(1000), rand(10000)]
  p.save!
end

ays = AcademicYear.all
User.where(role_id: 103).each do |u|
  Student.find_or_create_by(person_id: u.person_id) do |s|
    s.inst_id = "%06d" % rand(1000000)
    s.catalog_year = ays.sample
  end
end
