require 'rails_helper'

RSpec.describe "ClassMeetingAttributes", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/class_meeting_attribute/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/class_meeting_attribute/create"
      expect(response).to have_http_status(:success)
    end
  end

end
