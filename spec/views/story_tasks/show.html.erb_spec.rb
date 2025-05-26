require 'rails_helper'

RSpec.describe "story_tasks/show", type: :view do
  classSetup object: :create_story_task,
             user: :admin_user

  views_models_show
end
