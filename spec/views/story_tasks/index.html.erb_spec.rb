require 'rails_helper'

RSpec.describe "story_tasks/index", type: :view do
  classSetup objects: [
               :create_story_task,
               :create_story_task
             ],
             user: :admin_user

  views_models_index
end
