FactoryBot.define do
  factory :user do
    email { 'user@test.com' }
    role_id { User::RoleNone }
    password { "xyzzy!" }
    password_confirmation { "xyzzy!" }
    factory :admin_user do
      email { 'admin@data4he.com' }
      role_id { User::RoleAdmin }
    end
    factory :student_user do
      email { 'student000@demo.edu' }
      role_id { User::RoleStudent }
      person factory: :student_person
    end
    factory :student_user_1 do
      email { 'student001@demo.edu' }
      role_id { User::RoleStudent }
      person factory: :student_person_1
    end
  end
end
