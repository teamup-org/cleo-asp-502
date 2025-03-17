require "rails_helper"

RSpec.describe TranscriptCoursesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/transcript_courses").to route_to("transcript_courses#index")
    end

    it "routes to #new" do
      expect(get: "/transcript_courses/new").to route_to("transcript_courses#new")
    end

    it "routes to #show" do
      expect(get: "/transcript_courses/1").to route_to("transcript_courses#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/transcript_courses/1/edit").to route_to("transcript_courses#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/transcript_courses").to route_to("transcript_courses#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/transcript_courses/1").to route_to("transcript_courses#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/transcript_courses/1").to route_to("transcript_courses#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/transcript_courses/1").to route_to("transcript_courses#destroy", id: "1")
    end
  end
end
