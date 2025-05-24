require "rails_helper"

RSpec.describe StoryNotesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/story_notes").to route_to("story_notes#index")
    end

    it "routes to #new" do
      expect(get: "/story_notes/new").to route_to("story_notes#new")
    end

    it "routes to #show" do
      expect(get: "/story_notes/1").to route_to("story_notes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/story_notes/1/edit").to route_to("story_notes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/story_notes").to route_to("story_notes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/story_notes/1").to route_to("story_notes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/story_notes/1").to route_to("story_notes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/story_notes/1").to route_to("story_notes#destroy", id: "1")
    end
  end
end
