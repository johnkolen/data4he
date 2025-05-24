json.extract! story_note, :id, :note, :author, :story_task_id, :created_at, :updated_at
json.url story_note_url(story_note, format: :json)
