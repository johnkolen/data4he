json.extract! person, :id, :first_name, :last_name, :date_of_birth, :ssn, :created_at, :updated_at
json.url person_url(person, format: :json)
