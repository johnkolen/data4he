require "rails_helper"

RSpec.describe StoryTasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/story_tasks").to route_to("story_tasks#index")
    end

    it "routes to #new" do
      expect(get: "/story_tasks/new").to route_to("story_tasks#new")
    end

    it "routes to #show" do
      expect(get: "/story_tasks/1").to route_to("story_tasks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/story_tasks/1/edit").to route_to("story_tasks#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/story_tasks").to route_to("story_tasks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/story_tasks/1").to route_to("story_tasks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/story_tasks/1").to route_to("story_tasks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/story_tasks/1").to route_to("story_tasks#destroy", id: "1")
    end
  end
end
