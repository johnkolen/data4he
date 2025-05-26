require 'rails_helper'

RSpec.describe "story_tasks/new", type: :view do
  classSetup object: :build_story_task,
             user: :admin_user

  views_models_new
end
