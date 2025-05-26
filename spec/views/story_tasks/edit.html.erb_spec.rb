require 'rails_helper'

RSpec.describe "story_tasks/edit", type: :view do
  classSetup object: :create_story_task,
             user: :admin_user

  views_models_edit
end
