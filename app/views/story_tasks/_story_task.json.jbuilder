json.extract! story_task, :id, :title, :description, :priority, :status_id, :created_at, :updated_at
json.url story_task_url(story_task, format: :json)
